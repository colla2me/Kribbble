import Foundation

public protocol ServerConfigType {
	var apiBaseUrl: URL { get }
	var redirectUrl: URL { get }
	var apiClientAuth: OauthProvider { get }
}

public func == (lhs: ServerConfigType, rhs: ServerConfigType) -> Bool {
	return
		type(of: lhs) == type(of: rhs) &&
			lhs.apiBaseUrl == rhs.apiBaseUrl &&
			lhs.redirectUrl == rhs.redirectUrl &&
			lhs.apiClientAuth == rhs.apiClientAuth
}

public struct ServerConfig: ServerConfigType {

	public fileprivate(set) var apiBaseUrl: URL
	public fileprivate(set) var redirectUrl: URL
	public fileprivate(set) var apiClientAuth: OauthProvider
	
	public static let development: ServerConfigType = ServerConfig(
		apiBaseUrl: URL(string: Secrets.Api.base)!,
		redirectUrl: URL(string: Secrets.Dribbble.redirectURI)!,
		apiClientAuth: ClientAuth.local
	)
	
	public init(apiBaseUrl: URL,
				redirectUrl: URL,
				apiClientAuth: OauthProvider) {
		self.apiBaseUrl = apiBaseUrl
		self.redirectUrl = redirectUrl
		self.apiClientAuth = apiClientAuth
	}
}
