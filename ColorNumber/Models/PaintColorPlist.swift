//
//  PaintColorPlist.swift
//  ColorNumber
//
//  Created by HoangLuyen on 1/7/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import Foundation

class PaintColorPlist {
    var hex: String
    var number: Int
    init(hex: String, number: Int) {
        self.hex = hex
        self.number = number
    }
    convenience init?(dictionary: JSON) {
        guard let hex = dictionary["hex"] as? String, let number = dictionary["number"] as? Int else { return nil }
        self.init(hex: hex, number: number)
    }
}
