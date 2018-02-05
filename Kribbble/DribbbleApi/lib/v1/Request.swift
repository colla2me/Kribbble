import Foundation

public protocol Request {
	associatedtype Response: Codable
	
	var host: URL { get }
	
	var method: HTTPMethod { get }
	
	var path: String { get }
	
	var query: [String: Any] { get }
	
	var header: [String: String]? { get }
	
	var file: (name: String, url: URL)? { get }
	
	func parse(from data: Data) throws -> Response
}

fileprivate let decoder = JSONDecoder()

extension Request {
	
	public var host: URL {
		return ServerConfig.development.apiBaseUrl
	}
	
	public var query: [String: Any] {
		return [:]
	}
	
	public var method: HTTPMethod {
		return .GET
	}
	
	public var header: [String: String]? {
		return nil
	}
	
	public var file: (name: String, url: URL)? {
		return nil
	}
	
	public var url: URL {
		return host.appendingPathComponent(path)
	}
	
	public func parse(from data: Data) throws -> Response {
		if #available(iOS 10.0, *) {
			decoder.dateDecodingStrategy = .iso8601
		} else {
			// Fallback on earlier versions
			decoder.dateDecodingStrategy = .custom(Format.iso8601Decoder)
		}
		return try decoder.decode(Response.self, from: data)
	}
}
