//
//  PixelState.swift
//  ColorNumber
//
//  Created by Chung-Sama on 2018/01/07.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

public struct PixelState: Hashable {
    let x: Int
    let y: Int
    let color: UIColor
    
    public var hashValue: Int {
        return "\(x)\(y)\(color)".hashValue
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: PixelState, rhs: PixelState) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.color == rhs.color
    }
}
