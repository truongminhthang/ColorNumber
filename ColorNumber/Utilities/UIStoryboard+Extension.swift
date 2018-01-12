//
//  UIStoryboard+Extension.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit
fileprivate let _main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
fileprivate let _import: UIStoryboard = UIStoryboard(name: "Import", bundle: nil)
fileprivate let _library: UIStoryboard = UIStoryboard(name: "Library", bundle: nil)

extension UIStoryboard {
    
    static var main: UIStoryboard {
        get {
            return _main
        }
    }
    
    func viewControllerOf<T: UIViewController>(type: T.Type) -> T {
        return viewControllerOf(withIdentifier: String(describing: type)) as! T
    }
    
    func viewControllerOf(withIdentifier identifier: String) -> UIViewController {
        return instantiateViewController(withIdentifier: identifier)
    }
    
}

