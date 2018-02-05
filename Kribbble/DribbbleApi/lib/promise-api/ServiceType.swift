import Foundation
import PromiseKit

public protocol ServiceType {
	var serverConfig: ServerConfigType { get }
	var oauthToken: OauthTokenAuthType? { get }
	
	init(serverConfig: ServerConfigType, oauthToken: OauthTokenAuthType?)

	func fetchShots() -> Promise<[Shot]>
	
	// TODO: fetchUserShot() -> Promise<[Shot]>...
}

extension ServiceType {

	public var isAuthenticated: Bool {
		return self.oauthToken != nil
	}
}

extension ServiceType {
	
	public func preparedRequest(for originalRequest: URLRequest, query: [String: Any] = [:])
		-> URLRequest {
			
			var request = originalRequest
			guard let URL = request.url else {
				return originalRequest
			}
			
			var headers = self.defaultHeaders
			headers["If-None-Match"] = Service.etag
			
			let method = request.httpMethod?.uppercased()
			
			var components = URLComponents(url: URL, resolvingAgainstBaseURL: false)!
			var queryItems = components.queryItems ?? []
//			queryItems.append(contentsOf: self.defaultQueryParams.map(URLQueryItem.init(name:value:)))
			
			if method == .some("POST") || method == .some("PUT") {
				if request.httpBody == nil {
					headers["Content-Type"] = "application/json; charset=utf-8"
					request.httpBody = try? JSONSerialization.data(withJSONObject: query, options: [])
				}
			} else {
				queryItems.append(
					contentsOf: query
						.flatMap(queryComponents)
						.map(URLQueryItem.init(name:value:))
				)
			}
			components.queryItems = queryItems.sorted { $0.name < $1.name }
			request.url = components.url
			
			headers.forEach {
				request.setValue($1, forHTTPHeaderField: $0)
			}
			
			return request
	}
	
	public func preparedRequest(for url: URL, method: HTTPMethod = .GET, query: [String: Any] = [:])
		-> URLRequest {
			var request = URLRequest(
				url: url,
				cachePolicy: .reloadIgnoringLocalCacheData,
				timeoutInterval: 30)
			request.httpMethod = method.rawValue
			return self.preparedRequest(for: request, query: query)
	}
	
	fileprivate var defaultQueryParams: [String: String] {
		var query: [String: String] = [:]
		query["client_id"] = self.serverConfig.apiClientAuth.clientId
		query["oauth_token"] = self.oauthToken?.token
		return query
	}
	
	fileprivate var defaultHeaders: [String: String] {
		var headers: [String: String] = [:]
		let accessToken: String = Secrets.Dribbble.clientAccessToken
		headers["Authorization"] = "Bearer \(accessToken)"
		
		guard let infoDictionary: [String : Any] = Bundle.main.infoDictionary else {
			return headers
		}
		let executable = infoDictionary["CFBundleExecutable"] as? String
		let bundleIdentifier = infoDictionary["CFBundleIdentifier"] as? String
		let app: String = executable ?? bundleIdentifier ?? "SwiftDribbble"
		let bundleVersion: String = (infoDictionary["CFBundleVersion"] as? String) ?? "1"
		let model: String = UIDevice.current.model
		let systemVersion: String = UIDevice.current.systemVersion
		let scale: CGFloat = UIScreen.main.scale
		
		headers["User-Agent"] = "\(app)/\(bundleVersion) (\(model); iOS \(systemVersion) Scale/\(scale))"
		return headers
	}
	
	fileprivate func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
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
