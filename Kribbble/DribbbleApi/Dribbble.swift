import Foundation

public struct Dribbble {
	public static var oauthToken: OauthTokenAuthType? = nil
	public static let cache: NSCache = NSCache<NSString, AnyObject>()
	public static let apiService: ServiceType = Service(
		serverConfig: ServerConfig.development
	) 
}
