//
//  Image.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/15/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

struct Color {
    
}



struct MapIntensityColor {
    var count : CGFloat = 0
    var color: UIColor = UIColor(red:1, green: 1, blue: 1, alpha: 1)
    var totalRedColor: CGFloat = 0
    var totalBlueColor: CGFloat = 0
    var totalGreenColor: CGFloat = 0
    mutating func addColor (red: UInt8, green: UInt8, blue: UInt8) {
        count += 1
        totalRedColor += CGFloat(red)
        totalGreenColor += CGFloat(green)
        totalBlueColor += CGFloat(blue)
        color = UIColor(red: totalRedColor  / (count * 255), green: totalGreenColor  / (count * 255), blue: totalBlueColor / (count * 255), alpha: 1)
    }
}



class Image {
    var isEdited = false
    var image : UIImage
    var width: Int
    var height: Int
    static var patternColors = [UIColor](repeating: UIColor.white, count: 11)
    subscript (rowIndex: Int, heightIndex:Int) -> Pixel {
        return pixels[rowIndex][heightIndex]
    }
    var pixels : [[Pixel]] = []
    init(image: UIImage) {
        self.image = image
        self.width = Int(image.size.width)
        self.height = Int(image.size.height)
        
        let dataProvider = image.cgImage?.dataProvider
        let pixelData    = dataProvider?.data
        let pixelPointer = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = 4
        pixels = (0..<self.height).map { row in
            (0..<self.width).map { col in
                let offset = ((width * row) + col) * bytesPerPixel
                let pixel = Pixel(pointer: pixelPointer!, offset: offset, row: row,  col: col)
                self.calculateIntensity(for: pixel)
                return pixel
            }
        }
    }
    
    func calculateIntensity(for pixel: Pixel) {
        // Normalize the pixel's grayscale value to between 0 and 1.
        // Weights from http://en.wikipedia.org/wiki/Grayscale#Luma_coding_in_video_systems
        let
        redWeight   = 0.229,
        greenWeight = 0.587,
        blueWeight  = 0.114,
        weightedMax = 255.0 * redWeight   +
            255.0 * greenWeight +
            255.0 * blueWeight,
        weightedSum = Double(pixel.red ) * redWeight   +
            Double(pixel.green ) * greenWeight +
            Double(pixel.blue ) * blueWeight
        let intensity = weightedSum / weightedMax
        pixel.intensity =  intensity
        Image.patternColors[Int(intensity * 10)] = UIColor(red: CGFloat(pixel.red) / 255, green: CGFloat(pixel.green) / 255, blue: CGFloat(pixel.blue) / 255, alpha: 1)
    }


}

