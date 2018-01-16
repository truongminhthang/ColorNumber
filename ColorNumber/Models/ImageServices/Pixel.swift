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
    weak var delegateToImage: PixelDelegate? {
        didSet {
            delegateToImage?.arrangePatternColor(pixel: self)
        }
    }
    var type: PixelType
    var coordinate: Coordinate
    var color: Color
    var grayColor: UIColor
    var intensity: Double
    var intensityNumber : Int = 0
    var isEmpharse: Bool = false {
        didSet {
            backgroundColor = isEmpharse ? UIColor.green : grayColor
        }
    }
    var fillColorNumber : Int? {
        didSet {
            guard let fillNumber = fillColorNumber  else {return}
            if fillNumber == intensityNumber {
                text = ""
            }
        }
    }
        
    init(color: Color, coordinate: Coordinate, intensity: Double, type: PixelType) {
        self.type = type
        self.coordinate = coordinate
        self.color = color
        self.intensity = intensity
        self.intensityNumber = Int(intensity * 10)
        let frame = CGRect(origin: coordinate.originPoint, size: Pixel.size)
        grayColor = UIColor.black.withAlphaComponent(1-CGFloat(intensityNumber)/CGFloat(10))
        super.init(frame: frame)
        
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 5)
        switch type {
        case .number:
            if intensityNumber == 10 {
                layer.borderColor = UIColor.lightGray.cgColor
                layer.borderWidth = 0.1
                text = ""
            } else {
                layer.borderColor = UIColor.black.cgColor
                layer.borderWidth = 0.1
                text = String(intensityNumber)
            }
            
        case .color:
            text = ""
            backgroundColor = grayColor
        }
       
    }
    convenience init(pointer: PixelPointer, offset: Int, coordinate: Coordinate, type: PixelType) {
        let red   =  pointer[offset + 0]
        let green =  pointer[offset + 1]
        let blue  =  pointer[offset + 2]
        let color = Color(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue))
        let intensity = Pixel.calculateIntensity(red: red, green: green, blue: blue)
        self.init(color: color, coordinate: coordinate, intensity: intensity, type: type)
    }
    
    convenience init(_ pixel: Pixel) {
        self.init(color: pixel.color, coordinate: pixel.coordinate, intensity: pixel.intensity, type: .color)
    }
    
    func makeDuplicate() -> Pixel
    {
        return Pixel(self)
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
