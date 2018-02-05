import Foundation

public struct ClientAuth: OauthProvider {
	
	public let clientId: String
	
	public let clientSecret: String
	
	public let scopes: [Scope]
	
	public init(clientId: String, clientSecret: String, scopes: [Scope]) {
		self.clientId = clientId
		self.clientSecret = clientSecret
		self.scopes = scopes
	}
	
	public var authorizationURL: URL {
		let scope = scopes.map{ $0.rawValue }.joined(separator: "+")
		return URL(string: "https://dribbble.com/oauth/authorize?client_id=\(clientId)&scope=\(scope)")!
	}
	
	public static let local: OauthProvider = ClientAuth(
		clientId: Secrets.Dribbble.clientId,
		clientSecret: Secrets.Dribbble.clientSecret,
		scopes: [.Public, .Upload]
	)
}
