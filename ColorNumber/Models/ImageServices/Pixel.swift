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
    private var type: PixelType
    private var coordinate: Coordinate
    var color: Color
    var grayColor: UIColor
    private var intensity: Double
    var intensityNumber : Int = 0
    
    var isEmpharse: Bool = false {
        didSet {
            if isEmpharse {
                 effectBackgroundColor = UIColor.green
            } else {
                if type == .color {
                    effectBackgroundColor = grayColor
                } else if type == .number {
                    effectBackgroundColor = UIColor.clear
                }
            }
        }
    }
    private var _fillColorNumber : Int? {
        didSet {
            if let fillNumber = fillColorNumber  {
                if fillNumber == intensityNumber {
                    // Dung
                    drawWhenFillRight()
                    AppDelegate.shared.patternColors[intensityNumber].count -= 1
                   
                } else {
                    // Sai
                    drawWhenFillWrong(at: fillNumber)
                    if oldValue != nil {
                        AppDelegate.shared.patternColors[intensityNumber].count += 1
                    }
                }
            } else {
                // Earse
                setupBorderAndText()
                if oldValue == intensityNumber { //dang dung tay di
                    AppDelegate.shared.patternColors[intensityNumber].count += 1
                }
            }
        }
    }
    
    // Test case 1:  dung -> sai -> xoa             cout ko doi            : pass
    // Test case 2:  dung -> xoa -> sai             cout ko doi             : pass
    // Test case 3:  sai ->  dung -> xoa            count ko doi             : pass
        // Test case 5: xoa -> dung -> sai            count ko doi              : pass
    // Test case 4:  sai -> xoa  -> dung             count - 1              : pass
    // Test case 6: xoa -> sai -> dung            count - 1                  : pass


    var fillColorNumber : Int? {
        set {
            if intensityNumber != 10 && _fillColorNumber != newValue {
                _fillColorNumber = newValue
            }
        }
        get {
            return _fillColorNumber
        }
        
    }
    
    var effectBackgroundColor: UIColor? {
        set {
            guard _fillColorNumber == nil else {return}
            backgroundColor = newValue
        }
        get {
           
            return backgroundColor
        }
    }
    
    func drawWhenFillRight() {
        text = ""
        backgroundColor = AppDelegate.shared.patternColors[_fillColorNumber!].color.uiColor
        layer.borderColor = nil
        layer.borderWidth = 0
    }
    
    func drawWhenFillWrong(at fillNumber: Int) {
        backgroundColor = AppDelegate.shared.patternColors[fillNumber].color.tranperentColor
        text = "\(intensityNumber)"
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
        setupBorderAndText()
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
    }
    
    func setupBorderAndText() {
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
            effectBackgroundColor = UIColor.clear
        case .color:
            text = ""
            effectBackgroundColor = grayColor
        }
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 5)
    }
    
}

