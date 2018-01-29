//
//  PixelInfo.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/27/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

public class PixelInfo: NSObject, NSCoding {
    
    // MARK: - Properties
    var red: Double
    var green: Double
    var blu: Double
    
    var intensity: Int
    var color: UIColor
    var originPoint: CGPoint
    var originVideo: CGPoint
    
    // MARK: - Types
    struct PropertyKey {
        static let intensity = "intensity"
        static let originPoint = "originPoint"
        static let originVideo = "originVideo"
        static let red = "red"
        static let green = "green"
        static let blu = "blu"
    }
    
    init(intensity: Int, originPoint: CGPoint = .zero, originVideo: CGPoint = .zero, red: Double = 1.0, green: Double = 1.0, blu: Double = 1.0) {
        self.intensity = intensity
        self.red = red
        self.green = green
        self.blu = blu
        self.color = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blu), alpha: 1)
        self.originPoint = originPoint
        self.originVideo = originVideo
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let intensity = aDecoder.decodeInteger(forKey: PropertyKey.intensity)
        let originPoint = aDecoder.decodeCGPoint(forKey: PropertyKey.originPoint)
        let originVideo = aDecoder.decodeCGPoint(forKey: PropertyKey.originVideo)
        let red = aDecoder.decodeDouble(forKey: PropertyKey.red)
        let green = aDecoder.decodeDouble(forKey: PropertyKey.green)
        let blu = aDecoder.decodeDouble(forKey: PropertyKey.blu)
        self.init(intensity: intensity, originPoint: originPoint, originVideo: originVideo, red: red, green: green, blu: blu)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(intensity, forKey: PropertyKey.intensity)
        aCoder.encode(originPoint, forKey: PropertyKey.originPoint)
        aCoder.encode(originVideo, forKey: PropertyKey.originVideo)
        aCoder.encode(red, forKey: PropertyKey.red)
        aCoder.encode(green, forKey: PropertyKey.green)
        aCoder.encode(blu, forKey: PropertyKey.blu)
    }
}
