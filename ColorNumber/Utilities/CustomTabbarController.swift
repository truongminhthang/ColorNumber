//
//  Custom.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit

class CustomTabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // make unselected icons white
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.tintColor = UIColor.red
    }
}
