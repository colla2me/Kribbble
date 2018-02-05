//
//  DribbbleTabBarController.swift
//  SwiftDribbble
//
//  Created by Samuel on 2017/10/22.
//  Copyright © 2017年 Samuel. All rights reserved.
//

import UIKit

class DribbbleTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		UITabBar.appearance().tintColor = UIColor(red: 228.0/255.0, green: 74.0/255.0, blue: 135.0/255.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
