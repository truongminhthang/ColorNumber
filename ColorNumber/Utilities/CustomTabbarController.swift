//
//  Custom.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit

class CustomTabbarController: UITabBarController {
    
    var lastIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // make unselected icons white
        tabBar.unselectedItemTintColor = UIColor.white
        tabBar.tintColor = UIColor.red
        registerNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAdMob.sharedInstance.isBannerDisplay = false
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showTabBar), name: .showTabBar , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideTabBar), name: .hideTabBar , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backToHome), name: .backToHome , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func showTabBar(_ notification: Notification) {
        lastIndex =  (notification.object as? Int) ?? 0
        tabBar.isHidden = false
    }
    @objc
    func hideTabBar(_ notification: Notification) {
        tabBar.isHidden = true
    }

    @objc
    func backToHome(_ notification: Notification) {
        selectedIndex = lastIndex
        tabBar.isHidden = false

    }
    
    
}
