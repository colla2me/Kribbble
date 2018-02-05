import UIKit
import SafariServices

public class OauthWebViewController: SFSafariViewController {
	
	public typealias AuthenticatedHandler = (OauthToken) -> Void
	public typealias FailureHandler = (Error) -> Void
	public var authenticatedHandler: AuthenticatedHandler?
	public var failureHandler: FailureHandler?

	private let provider: OauthProvider
	
	public required init(provider: OauthProvider) {
		self.provider = provider
		super.init(
			url: provider.authorizationURL,
			entersReaderIfAvailable: false
		)
	}
	
	public func authorize(with code: String) {
		let tokenRequest = OauthTokenRequest(
			clientId: provider.clientId,
			clientSecret: provider.clientSecret,
			code: code
		)
		
		Session.send(tokenRequest) { (result) in
			switch result {
			case .success(let oauthToken):
				print("oauth token is: ", oauthToken)
				self.authenticatedHandler?(oauthToken)
				self.dismiss(animated: true, completion: nil)
				
			case .failure(let error):
				print("oauth error: ", error)
				self.failureHandler?(error)
			}
		}
	}
}
