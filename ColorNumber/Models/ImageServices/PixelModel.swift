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
class PixelModel: Equatable {
    /** The number of bytes a pixel occupies. 1 byte per channel (RGBA). */
    static var size = CGSize(width: 10, height: 10)
    let maxIntensity :Double = 11
    static let intensityToDisable = 10
    
    var pixelAnatomic: PixelAnatomic
    var color: Color
    var grayColor: UIColor
    private var intensity: Double
    var intensityNumber : Int = 0
    
    var numberLabel: UILabel
    var colorLabel: UILabel
    
    var isEmpharse: Bool = false {
        didSet {
            if isEmpharse {
                if fillColorNumber == nil {
                    // Chua set mau
                    colorLabel.backgroundColor = UIColor.green
                    numberLabel.backgroundColor = UIColor.green
                }
            } else {
                // Da set roi thi set lai mau da set
                if let fillNumber = fillColorNumber  {
                    colorLabel.backgroundColor = DataService.share.selectedImage!.patternColors[fillNumber].color.uiColor
                    numberLabel.backgroundColor = DataService.share.selectedImage!.patternColors[fillNumber].color.uiColor
                } else {
                    // chua set mau thi set mau Gray Color
                    colorLabel.backgroundColor = grayColor
                    numberLabel.backgroundColor = UIColor.clear
                }
            }
        }
    }
    private var _fillColorNumber : Int? {
        didSet {
            pixelAnatomic.fillColorNumber = _fillColorNumber

            if let fillNumber = fillColorNumber  {
                if fillNumber == intensityNumber {
                    // Dung
                    drawWhenFillRight()
                    DataService.share.selectedImage!.patternColors[intensityNumber].count -= 1
                        // insert To Stack
                        DataService.share.selectedImage?.pixelStack.append(pixelAnatomic)
                } else {
                    // Sai
                    drawWhenFillWrong(at: fillNumber)
                    if oldValue != nil {
                        DataService.share.selectedImage!.patternColors[intensityNumber].count += 1
                            // Remove from Stack
                            DataService.share.selectedImage?.pixelStack.remove(object:pixelAnatomic)
                    }
                }
            } else {
                // Earse
                setupBorderAndText()
                if oldValue == intensityNumber { //dang dung tay di
                    DataService.share.selectedImage!.patternColors[intensityNumber].count += 1
                        // Remove from Stack
                        DataService.share.selectedImage?.pixelStack.remove(object:pixelAnatomic)
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
            if intensityNumber < PixelModel.intensityToDisable && _fillColorNumber != newValue {
                _fillColorNumber = newValue
            }
        }
        get {
            return _fillColorNumber
        }
        
    }
    
    func drawWhenFillRight() {
        numberLabel.text = ""
        numberLabel.backgroundColor = DataService.share.selectedImage!.patternColors[_fillColorNumber!].color.uiColor
        colorLabel.backgroundColor = DataService.share.selectedImage!.patternColors[_fillColorNumber!].color.uiColor
        numberLabel.layer.borderColor = nil
        numberLabel.layer.borderWidth = 0
    }
    
    func drawWhenFillWrong(at fillNumber: Int) {
        numberLabel.backgroundColor = DataService.share.selectedImage!.patternColors[fillNumber].color.tranperentColor
        colorLabel.backgroundColor = DataService.share.selectedImage!.patternColors[fillNumber].color.uiColor
        numberLabel.text = "\(intensityNumber)"
    }
    
    
    
    init(color: Color, pixelAnatomic: PixelAnatomic, intensity: Double) {
        self.pixelAnatomic = pixelAnatomic
        self.color = color
        self.intensity = intensity
        self.intensityNumber = Int(intensity * maxIntensity)
        let frame = CGRect(origin: pixelAnatomic.originPoint, size: PixelModel.size)
        grayColor = UIColor.black.withAlphaComponent(1-CGFloat(intensityNumber)/CGFloat(maxIntensity))
        numberLabel = UILabel(frame: frame)
        colorLabel = UILabel(frame: frame)
        setupBorderAndText()
    }
    
    convenience init(pointer: PixelPointer, offset: Int, pixelAnatomic: PixelAnatomic) {
        let red   =  pointer[offset + 0]
        let green =  pointer[offset + 1]
        let blue  =  pointer[offset + 2]
        let color = Color(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue))
        let intensity = PixelModel.calculateIntensity(red: red, green: green, blue: blue)
        self.init(color: color, pixelAnatomic: pixelAnatomic, intensity: intensity)
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
        setupColorLabel()
        setupNumberLabel()
    }
    
    func setupColorLabel() {
        if intensityNumber >= PixelModel.intensityToDisable {
            colorLabel.backgroundColor = UIColor.white
        } else {
            colorLabel.backgroundColor = grayColor
        }
        colorLabel.text = ""
    }
    
    func setupNumberLabel() {
        if intensityNumber >= PixelModel.intensityToDisable {
            numberLabel.layer.borderColor = UIColor.lightGray.cgColor
            numberLabel.layer.borderWidth = 0.1
            numberLabel.text = ""
        } else {
            numberLabel.layer.borderColor = UIColor.black.cgColor
            numberLabel.layer.borderWidth = 0.1
            numberLabel.text = String(intensityNumber)
        }
        numberLabel.backgroundColor = UIColor.clear
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont.systemFont(ofSize: 5)
    }
    
    static func ==(lhs: PixelModel, rhs: PixelModel) -> Bool {
        return (lhs.pixelAnatomic.col == rhs.pixelAnatomic.col) && (lhs.pixelAnatomic.row == rhs.pixelAnatomic.row)
    }
    
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

