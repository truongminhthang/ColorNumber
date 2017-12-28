//
//  UILabel+Extention.swift
//  ColorNumber
//
//  Created by ChungTran on 12/28/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit
@IBDesignable
class DesignableLabel: UILabel {
    @IBInspectable var unitFontScreen: CGFloat = 3
    @IBInspectable var fontWithScreen: CGFloat = 9 {
        didSet {
            let widthScreen = UIScreen.main.bounds.width
            if widthScreen >= 320 && widthScreen < 375  {
                self.font = UIFont.systemFont(ofSize: fontWithScreen)
            } else if widthScreen >= 375 && widthScreen < 414 {
                self.font = UIFont.systemFont(ofSize: fontWithScreen + unitFontScreen)
            } else if widthScreen >= 414 {
                self.font = UIFont.systemFont(ofSize: fontWithScreen + 2*unitFontScreen)
            }
        }
    }

}
