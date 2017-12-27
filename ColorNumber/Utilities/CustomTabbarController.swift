//
//  Custom.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit

class CustomTabbarController: UITabBarController {
    ///
    /// Tabbar item color (normal state)
    ///
    @IBInspectable var itemNormalColor: UIColor = UIColor.lightGray {
        didSet {
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: itemNormalColor], for:UIControlState());
            let items = tabBar.items! ;
            for item in items {
                item.image = item.image!.imageWithColor(tintColor: itemNormalColor).withRenderingMode(UIImageRenderingMode.alwaysOriginal);
            }
            
        }
    }
    
    ///
    /// Tabbar item color (selected state)
    ///
    @IBInspectable var itemSelectedColor: UIColor = UIColor.white {
        didSet {
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: itemSelectedColor], for:UIControlState.selected);
            let items = tabBar.items! ;
            for item in items {
                item.selectedImage = item.image?.imageWithColor(tintColor: itemSelectedColor).withRenderingMode(.alwaysOriginal)
            }
        }
    }
}


