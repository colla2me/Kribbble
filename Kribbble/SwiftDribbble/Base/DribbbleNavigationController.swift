//
//  DribbbleNavigationController.swift
//  SwiftDribbble
//
//  Created by Samuel on 2017/10/22.
//  Copyright © 2017年 Samuel. All rights reserved.
//

import UIKit

class DribbbleNavigationController: UINavigationController {

	let barTintColor = UIColor(red: 53/255, green: 53/255, blue: 53/255, alpha: 1.0)
	
    override func viewDidLoad() {
        super.viewDidLoad()
//		dribbbleStyleNavigationBar()
		let navigationBarAppearace = UINavigationBar.appearance()
		navigationBarAppearace.barTintColor = barTintColor
		navigationBarAppearace.tintColor = UIColor.white
    }
	
	func dribbbleStyleNavigationBar() {
		let barView = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.bounds.width, height: 64))
		let gradLayer: CAGradientLayer = CAGradientLayer()
		gradLayer.frame = barView.bounds
		gradLayer.colors = [
			barTintColor.cgColor,
			barTintColor.withAlphaComponent(0.5).cgColor
		]
		gradLayer.startPoint = CGPoint(x: 0, y: 0)
		gradLayer.endPoint = CGPoint(x: 0, y: 1.0)
		barView.layer.addSublayer(gradLayer)
		self.navigationBar.addSubview(barView)
//		self.navigationBar.insertSubview(barView, at: 0)
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
