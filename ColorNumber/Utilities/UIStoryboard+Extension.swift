//
//  UIStoryboard+Extension.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit
fileprivate let _main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

extension UIStoryboard {
    
    static var main: UIStoryboard {
        get {
            return _main
        }
    }
    
    func viewControllerOf<T: UIViewController>(_ type: T.Type) -> T {
        return viewControllerOf(String(describing: type)) as! T
    }
    
    func viewControllerOf(_ identifier: String) -> UIViewController {
        return instantiateViewController(withIdentifier: identifier)
    }
    
}

