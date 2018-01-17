//
//  UIView+Extention.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if cornerRadius == -1 {
            self.layer.cornerRadius = self.bounds.width < self.bounds.height ? self.bounds.width * 0.5 : self.bounds.height * 0.5
        }
    }
}

@IBDesignable
class Label: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        if cornerRadius == -1 {
            self.layer.cornerRadius = self.bounds.width < self.bounds.height ? self.bounds.width * 0.5 : self.bounds.height * 0.5
        }
        self.clipsToBounds = true
    }
}


extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return CGFloat(tag)
            
        }
        set {
            layer.cornerRadius = newValue
            tag = Int(newValue)
            if newValue == -1 {
                self.clipsToBounds = true
                self.layer.cornerRadius = self.bounds.width < self.bounds.height ? self.bounds.width * 0.5 : self.bounds.height * 0.5
            } else {
                layer.masksToBounds = true
            }
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
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
    func animateToSmaller(animations: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.2, animations: {
            self.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1);
        }, completion: { (completed) in
            UIView.animate(withDuration: 0.2, animations: {
                self.layer.transform = CATransform3DMakeScale(1, 1, 1);
            }, completion: { (completed) in
                animations(completed)
            })
        })
        
    }
}
