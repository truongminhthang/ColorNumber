//
//  Color.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/17/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class Color: NSCoding {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var uiColor: UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    var tranperentColor: UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 0.7)
        
    }
    
    init(red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    struct Key {
        static let red = "red"
        static let green = "green"
        static let blue = "blue"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(red, forKey: Key.red)
        aCoder.encode(green, forKey: Key.green)
        aCoder.encode(blue, forKey: Key.blue)

    }
    
    required init?(coder aDecoder: NSCoder) {
        self.red = CGFloat(aDecoder.decodeFloat(forKey: Key.red))
        self.green = CGFloat(aDecoder.decodeFloat(forKey: Key.green))
        self.blue = CGFloat(aDecoder.decodeFloat(forKey: Key.blue))
    }
}

