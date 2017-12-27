//
//  UIImageView+Extention.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit

extension UIImageView {
    func animate(animations: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.2, animations: {
            self.layer.transform = CATransform3DMakeScale(1.25, 1.25, 1);
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.2, animations: {
                self.layer.transform = CATransform3DMakeScale(1, 1, 1);
            }, completion: { (completed) in
                animations(completed)
            })
        })
        
    }
}
