import Foundation

public enum Scope: String {
	case Public = "public"
	case Write = "write"
	case Comment = "comment"
	case Upload = "upload"
}

public protocol OauthProvider {
	var clientId: String { get }
	var clientSecret: String { get }
	var authorizationURL: URL { get }
	var scopes: [Scope] { get }
	init(clientId: String, clientSecret: String, scopes: [Scope])
}

public func == (lhs: OauthProvider, rhs: OauthProvider) -> Bool {
	return type(of: lhs) == type(of: rhs) &&
		lhs.clientId == rhs.clientId &&
		lhs.clientSecret == rhs.clientSecret &&
		lhs.authorizationURL == rhs.authorizationURL
}

extension OauthProvider {
	public var scopes: [Scope] {
		return [.Public]
	}
	
	public var state: String {
		return generateState(with: 16)
	}
	
	public func generateState(with len: Int) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		let length = UInt32(letters.count)
		
		var randomString = ""
		for _ in 0..<len {
			let rand = arc4random_uniform(length)
			let idx = letters.index(letters.startIndex, offsetBy: Int(rand))
			let letter = letters[idx]
			randomString += String(letter)
		}
		return randomString
	}
}
