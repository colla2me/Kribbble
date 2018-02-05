import UIKit

public enum Storyboard: String {
	case Following
	case Popular
	case Recent
	case Debuts
	case Animated
	case Rebounds
	case Playoffs
	case Teams
	
	public func instantiate<VC: UIViewController>(_ viewController: VC.Type, bundle: Bundle? = nil) -> VC {
		
		guard
			let vc = UIStoryboard(name: self.rawValue, bundle: bundle)
				.instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC
			else { fatalError("Couldn't instantiate \(VC.storyboardIdentifier) from \(self.rawValue)") }
		
		return vc
	}
}

extension UIViewController {
	public static var defaultNib: String {
		return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
	}
	
	public static var storyboardIdentifier: String {
		return self.description().components(separatedBy: ".").dropFirst().joined(separator: ".")
	}
}
