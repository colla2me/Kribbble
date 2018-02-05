//
//  AppDelegate.swift
//  SwiftDribbble
//
//  Created by Samuel on 2017/10/14.
//  Copyright © 2017年 Samuel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = UIColor.white
		window?.rootViewController = DribbbleNavigationController(
			rootViewController: PagerNodeController()
		)
		window?.makeKeyAndVisible()
		
		return true
	}

	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		guard url.scheme == "kribbble" else { return false }
		
		if let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems, let code = queryItems.first?.value {
			
			print("queryItems: \(queryItems)")
			
			if let rootVC = window?.rootViewController, let oauthWeb = rootVC.presentedViewController as? OauthWebViewController {
				
				oauthWeb.authorize(with: code)
			}
		}
		return true
	}

}
