import Foundation
import Result

private let boundary = "dr1b6b1er73r154c0mp4ny"

public final class Session {
	private let urlSession: URLSession!
	private var etag: String?
	
	private static let privateShared: Session = {
		let configuration = URLSessionConfiguration.default
		return Session(configuration: configuration)
	}()
	
	public init(configuration: URLSessionConfiguration) {
		self.urlSession = URLSession(configuration: configuration)
	}
	
	public class func send<T: Request>(_ request: T, handler: @escaping (Result<T.Response, SessionTaskError>) -> Void) {
		
		Session.privateShared.send(request, handler: handler)
	}
	
	public func send<T: Request>(_ r: T, handler: @escaping (Result<T.Response, SessionTaskError>) -> Void) {
		
		let request = self.preparedRequest(
			r.url,
			method: r.method,
			query: r.query,
			header: r.header,
			uploading: r.file
		)
		
		let task: URLSessionDataTask = self.urlSession.dataTask(with: request) { [weak self] (data, rsp, error) in
			
			let result: Result<T.Response, SessionTaskError>
			
			do {
				if let data = data {
					let json = try JSONSerialization.jsonObject(with: data, options: [])
					print("\n\n")
					print(json)
					print("\n\n")
				}
			} catch {
				print(error)
			}
			
			if let error = error {
				result = .failure(.connectionError(error))
			} else if let data = data, let rsp = rsp as? HTTPURLResponse, (200..<300) ~= rsp.statusCode {
				do {
					result = .success(try r.parse(from: data))
				} catch {
					result = .failure(.responseError(error))
				}
			} else if let rsp = rsp as? HTTPURLResponse, 304 == rsp.statusCode, let cache = URLCache.shared.cachedResponse(for: request)?.data {
				
				do {
					result = .success(try r.parse(from: cache))
				} catch {
					result = .failure(.responseError(error))
				}
			} else {
				result = .failure(.responseError(ResponseError.nonHTTPURLResponse(rsp)))
			}
			
			if let rsp = rsp as? HTTPURLResponse, let etag = rsp.allHeaderFields["Etag"] as? String {
				self?.etag = etag
			}
			
			DispatchQueue.main.async {
				handler(result)
			}
		}
		
		task.resume()
	}
}

extension Session {
	
	public func preparedRequest(
		_ url: URL,
		method: HTTPMethod = .GET,
		query: [String: Any] = [:],
		header: [String: String]? = nil,
		uploading file: (name: String, url: URL)? = nil) -> URLRequest {
		
		var request = URLRequest(
			url: url,
			cachePolicy: .reloadIgnoringLocalCacheData,
			timeoutInterval: 30)
		
		request.httpMethod = method.rawValue

		if let etag = etag {
			request.setValue(etag, forHTTPHeaderField: "If-None-Match")
		}
		
		if let header = header {
			header.forEach {
				request.setValue($1, forHTTPHeaderField: $0)
			}
		}
		
		var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
		var queryItems = components.queryItems ?? []
		
		if method == .POST || method == .PUT {
			if request.httpBody == nil {
				request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
				request.httpBody = try? JSONSerialization.data(withJSONObject: query, options: [])
			}
		} else {
			request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
			queryItems.append(contentsOf: parseQueryItems(query))
		}
		
		components.queryItems = queryItems.sorted { $0.name < $1.name }
		request.url = components.url
		self.defaultHeaders.forEach {
			request.setValue($1, forHTTPHeaderField: $0)
		}
		
		print("URL =====>", request.url as Any)
		
		if let file = file {
			return self.preparedUpload(for: request, uploading: file.url, named: file.name)
		}
		return request
	}
	
	public func preparedUpload(for request: URLRequest, uploading file: URL, named name: String) -> URLRequest {
		var mutableRequest = request
		guard
			let data = try? Data(contentsOf: file),
			let mime = file.imageMime ?? data.imageMime,
			let multipartHead = ("--\(boundary)\r\n"
				+ "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(file.lastPathComponent)\"\r\n"
				+ "Content-Type: \(mime)\r\n\r\n").data(using: .utf8),
			let multipartTail = "--\(boundary)--\r\n".data(using: .utf8)
			else { fatalError("uploading data or mime is nil") }
		var body = Data()
		body.append(multipartHead)
		body.append(data)
		body.append(multipartTail)
		mutableRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		mutableRequest.httpBody = body
		return mutableRequest
	}

	private var defaultHeaders: [String: String] {
		var headers: [String: String] = [:]
		let accessToken: String = Secrets.Dribbble.clientAccessToken
		headers["Authorization"] = "Bearer \(accessToken)"
	
		guard let infoDictionary: [String : Any] = Bundle.main.infoDictionary else {
			return headers
		}
		let executable = infoDictionary["CFBundleExecutable"] as? String
		let bundleIdentifier = infoDictionary["CFBundleIdentifier"] as? String
		let app: String = executable ?? bundleIdentifier ?? "kribbble"
		let bundleVersion: String = (infoDictionary["CFBundleVersion"] as? String) ?? "1"
		let model: String = UIDevice.current.model
		let systemVersion: String = UIDevice.current.systemVersion
		let scale: CGFloat = UIScreen.main.scale
		
		headers["User-Agent"] = "\(app)/\(bundleVersion) (\(model); iOS \(systemVersion) Scale/\(scale))"
		return headers
	}
	
	private func parseQueryItems(_ query: [String: Any]?) -> [URLQueryItem] {
		guard let query = query else { return [] }
		return query.flatMap(queryComponents)
			.map(URLQueryItem.init(name:value:))
	}
	
	private func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
		var components: [(String, String)] = []
		
		if let dictionary = value as? [String: Any] {
			for (nestedKey, value) in dictionary {
				components += queryComponents("\(key)[\(nestedKey)]", value)
			}
		} else if let array = value as? [Any] {
			for value in array {
				components += queryComponents("\(key)[]", value)
			}
		} else {
			components.append((key, String(describing: value)))
		}
		
		return components
	}
}
