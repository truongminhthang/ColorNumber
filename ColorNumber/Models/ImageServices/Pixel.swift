//
//  Pixel.swift
//  ColorNumber
//
//  Created by Chung-Sama on 2018/01/08.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit
/** Represents the memory address of a pixel. */
typealias PixelPointer = UnsafePointer<UInt8>

/** A point in an image converted to an ASCII character. */
class Pixel : UILabel {
    /** The number of bytes a pixel occupies. 1 byte per channel (RGBA). */
    var size = CGSize(width: 50, height: 50)
    var rowIndex: Int
    var columnIndex: Int
    var red: UInt8 = 0
    var green: UInt8 = 0
    var blue: UInt8 = 0
    var intensity: Double? {
        didSet {
            if let aIntensity = intensity {
                text = "\(Int(aIntensity * 10))"
                backgroundColor = UIColor.black.withAlphaComponent(1-CGFloat(Int(aIntensity * 10))/CGFloat(10))
            } else {
                text = ""
            }
        }
    }
    var isFillColor = false
        
    fileprivate let offset: Int
    init(pointer: PixelPointer, offset: Int, row: Int, col: Int) {
        self.offset = offset
        rowIndex = row
        columnIndex = col
        red   =  pointer[offset + 0]
        green =  pointer[offset + 1]
        blue  =  pointer[offset + 2]
        let frame = CGRect(origin: CGPoint(x: CGFloat(col) * size.width, y: CGFloat(row) * size.height), size: size)
        super.init(frame: frame)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.1
        self.textAlignment = .center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
