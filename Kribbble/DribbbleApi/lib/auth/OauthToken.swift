import Foundation

public protocol OauthTokenAuthType {
	var token: String { get }
	var scope: String { get }
}

public func == (lhs: OauthTokenAuthType, rhs: OauthTokenAuthType) -> Bool {
	return type(of: lhs) == type(of: rhs) &&
		lhs.token == rhs.token &&
		lhs.scope == rhs.scope
}

public func == (lhs: OauthTokenAuthType?, rhs: OauthTokenAuthType?) -> Bool {
	return type(of: lhs) == type(of: rhs) &&
		lhs?.token == rhs?.token &&
		lhs?.scope == rhs?.scope
}

public struct OauthToken: OauthTokenAuthType, Codable {
	public let token: String
	public let scope: String
	public let type: String
	
	private enum CodingKeys: String, CodingKey {
		case scope
		case token = "access_token"
		case type = "token_type"
	}
}

public struct OauthTokenRequest: Request {
	public typealias Response = OauthToken
	public let method: HTTPMethod = .POST
	public var query: [String : Any] = [:]
	
	public var host: URL {
		return URL(string: "https://dribbble.com")!
	}
	
	public var path: String {
		return "/oauth/token"
	}
	
	init(clientId: String, clientSecret: String, code: String) {
		self.query["client_id"] = clientId
		self.query["client_secret"] = clientSecret
		self.query["code"] = code
	}
}
