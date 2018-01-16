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

enum PixelType {
    case number, color
}

/** A point in an image converted to an ASCII character. */
class Pixel : UILabel {
    /** The number of bytes a pixel occupies. 1 byte per channel (RGBA). */
    static var size = CGSize(width: 10, height: 10)
    var type: PixelType
    var rowIndex: Int
    var columnIndex: Int
    var red: UInt8 = 0
    var green: UInt8 = 0
    var blue: UInt8 = 0
    var intensity: Double
    var isFillColor = false
        
    init(red: UInt8, green: UInt8, blue: UInt8, intensity: Double, row: Int, col: Int, type: PixelType) {
        self.type = type
        rowIndex = row
        columnIndex = col
        self.red = red
        self.blue = blue
        self.green = green
        self.intensity = intensity
        let frame = CGRect(origin: CGPoint(x: CGFloat(col) * Pixel.size.width, y: CGFloat(row) * Pixel.size.height), size: Pixel.size)
        super.init(frame: frame)
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 5)
        switch type {
        case .number:
            let displayIntensity = Int(intensity * 10)
            if displayIntensity == 10 {
                layer.borderColor = UIColor.lightGray.cgColor
                layer.borderWidth = 0.1
                text = ""
            } else {
                layer.borderColor = UIColor.black.cgColor
                layer.borderWidth = 0.1
                text = String(displayIntensity)
            }
            
        case .color:
            text = ""
            fillGrayColor()
        }
       
        

       
    }
    convenience init(pointer: PixelPointer, offset: Int, row: Int, col: Int, type: PixelType) {
        
        let red   =  pointer[offset + 0]
        let green =  pointer[offset + 1]
        let blue  =  pointer[offset + 2]
        let intensity = Pixel.calculateIntensity(red: red, green: green, blue: blue)
        self.init(red: red, green: green, blue: blue, intensity: intensity, row: row, col: col, type: type)

        
    }
    
    convenience init(_ pixel: Pixel) {
        self.init(red: pixel.red, green: pixel.green, blue: pixel.blue, intensity: pixel.intensity, row: pixel.rowIndex, col: pixel.columnIndex, type: .color)
    }
    
    func copy() -> Pixel
    {
        return Pixel(self)
    }
    
    
    func redrawFixel() {
        if isFillColor == false {
                fillGrayColor()
        } else {
            fillActualColor()
        }
    }
    
    fileprivate func fillGrayColor() {
        backgroundColor = UIColor.black.withAlphaComponent(1-CGFloat(Int(intensity * 10))/CGFloat(10))
    }
    
    fileprivate func fillActualColor() {
        backgroundColor = UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func calculateIntensity(red: UInt8, green: UInt8, blue: UInt8) -> Double {
        // Normalize the pixel's grayscale value to between 0 and 1.
        // Weights from http://en.wikipedia.org/wiki/Grayscale#Luma_coding_in_video_systems
        let
        redWeight   = 0.229,
        greenWeight = 0.587,
        blueWeight  = 0.114,
        weightedMax = 255.0 * redWeight   +
            255.0 * greenWeight +
            255.0 * blueWeight,
        weightedSum = Double(red ) * redWeight   +
            Double(green ) * greenWeight +
            Double(blue) * blueWeight
        return weightedSum / weightedMax
        
//        PixelImageView.patternColors[Int(intensity * 10)] = UIColor(red: CGFloat(pixel.red) / 255, green: CGFloat(pixel.green) / 255, blue: CGFloat(pixel.blue) / 255, alpha: 1)
    }
}
