//
//  Coordinate.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/17/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

struct Coordinate {
    var col: Int
    var row: Int
    
    var originPoint: CGPoint {
        return CGPoint(x: CGFloat(col) * Pixel.size.width, y: CGFloat(row) * Pixel.size.height)
    }
    var originVideo: CGPoint {
        return CGPoint(x: CGFloat(col) * Pixel.size.width , y: UIScreen.main.bounds.size.width - (CGFloat(row) + 1) * Pixel.size.height)
    }
}

