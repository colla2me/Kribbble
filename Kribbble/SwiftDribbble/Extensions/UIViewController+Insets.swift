import UIKit

extension UIViewController {
	
	var insetTop: CGFloat {
		var top: CGFloat = 0
		if !UIApplication.shared.isStatusBarHidden {
			top += UIApplication.shared.statusBarFrame.height
		}
		
		if let nav = navigationController, !nav.isNavigationBarHidden {
			top += nav.navigationBar.bounds.height
		}
		return top
	}
	
	var insetBottom: CGFloat {
		var bottom: CGFloat = 0
		if let tab = tabBarController, !tab.tabBar.isHidden {
			bottom += tab.tabBar.bounds.height
		}
		return bottom
	}
	
	var contentInsets: UIEdgeInsets {
		return UIEdgeInsetsMake(insetTop, 0, insetBottom, 0)
	}
}
