import Foundation
import PromiseKit
import Result

public struct Service: ServiceType {
	
	private static let session = URLSession(configuration: .default)
	private static let decoder = JSONDecoder()
	public static var etag: String? = nil
	public let serverConfig: ServerConfigType
	public let oauthToken: OauthTokenAuthType?
	
	public init(serverConfig: ServerConfigType, oauthToken: OauthTokenAuthType? = nil) {
		self.serverConfig = serverConfig
		self.oauthToken = oauthToken
		if #available(iOS 10.0, *) {
			Service.decoder.dateDecodingStrategy = .iso8601
		} else {
			// Fallback on earlier versions
			Service.decoder.dateDecodingStrategy = .custom(Format.iso8601Decoder)
		}
	}
	
	public func fetchShots() -> Promise<[Shot]> {
		return request(.shots)
	}
	
	// TODO: func fetchUserShot()....
	
	private func request<U: Decodable>(_ route: Route) -> Promise<U> {
		let properties = route.requestProperties
		let baseURL = self.serverConfig.apiBaseUrl
		let URL = baseURL.appendingPathComponent(properties.path)
		let request = preparedRequest(
			for: URL,
			method: properties.method,
			query: properties.query
		)

		let (promise, fulfill, reject) = Promise<U>.pending()
		
		Service.session.dataTask(with: request) {
			(data, rsp, error) in
			
			if let error = error {
				reject(error)
			} else if let data = data, let rsp = rsp as? HTTPURLResponse, (200..<300) ~= rsp.statusCode {
				do {
					let value = try Service.decoder.decode(U.self, from: data)
					fulfill(value)
				} catch {
					reject(error)
				}
			} else if let rsp = rsp as? HTTPURLResponse, 304 == rsp.statusCode, let cache = URLCache.shared.cachedResponse(for: request)?.data {
				do {
					let value = try Service.decoder.decode(U.self, from: cache)
					fulfill(value)
				} catch {
					reject(error)
				}
			} else {
				reject(PMKURLError.badResponse(request, data, rsp))
			}
			
			if let rsp = rsp as? HTTPURLResponse, let etag = rsp.allHeaderFields["Etag"] as? String {
				Service.etag = etag
			}
		}.resume()
	
		return promise
	}
}
