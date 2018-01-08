//
//  Pixel.swift
//  ColorNumber
//
//  Created by Thuy Truong Quang on 12/31/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import Foundation
import UIKit

struct Pixel {
    var red, green, blue, alpha: UInt8
    
    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    var color: UIColor {
        return UIColor(red: CGFloat(Double(red)/255.0), green: CGFloat(Double(green)/255.0), blue: CGFloat(Double(blue)/255.0), alpha: CGFloat(Double(alpha)/255.0))
    }
    
    var description: String {
        return "RGBA(\(red), \(green), \(blue), \(alpha))"
    }
}

extension Pixel : Equatable {
    public static func ==(lhs: Pixel, rhs: Pixel) -> Bool {
        return UInt32(lhs.hashValue) == UInt32(rhs.hashValue)
    }
}

extension Pixel : Comparable {
    public static func <(lhs: Pixel, rhs: Pixel) -> Bool {
        return UInt32(lhs.hashValue) < UInt32(rhs.hashValue)
    }
    
    public static func >(lhs: Pixel, rhs: Pixel) -> Bool {
        return UInt32(lhs.hashValue) > UInt32(rhs.hashValue)
    }
    
    public static func <=(lhs: Pixel, rhs: Pixel) -> Bool {
        return lhs < rhs || lhs == rhs
    }
    
    public static func >=(lhs: Pixel, rhs: Pixel) -> Bool {
        return lhs > rhs || lhs == rhs
    }
}

extension Pixel : Hashable {
    public var hashValue: Int {
        let redBits     = UInt32(red) << (8 * 3)
        let greenBits   = UInt32(green) << (8 * 2)
        let blueBits    = UInt32(blue) << (8 * 1)
        let alphaBits   = UInt32(alpha) << (8 * 0)
        return Int(redBits | greenBits | blueBits | alphaBits)
    }
}

extension UIImage {
    func pixelData() -> [Pixel] {
        guard let bmp = self.cgImage?.dataProvider?.data else {
            print("Error getting pixel data from image")
            return []
        }
        
        guard var data = CFDataGetBytePtr(bmp) else {
            print("Error getting pixel data from image")
            return []
        }
        
        var r, g, b, a: UInt8
        var pixels: [Pixel] = []
        
        for _ in 0..<Int(self.size.height)*Int(self.size.width) {
            r = data.pointee
            data = data.advanced(by: 1)
            g = data.pointee
            data = data.advanced(by: 1)
            b = data.pointee
            data = data.advanced(by: 1)
            a = data.pointee
            data = data.advanced(by: 1)
            
            pixels.append(Pixel(red: r, green: g, blue: b, alpha: a))
        }
        return pixels
    }
}
