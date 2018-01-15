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
struct Pixel {
    /** The number of bytes a pixel occupies. 1 byte per channel (RGBA). */
    static let bytesPerPixel = 4
    
    fileprivate let offset: Int
    fileprivate init(_ offset: Int) { self.offset = offset }
    
    static func createPixelMatrix(_ width: Int, _ height: Int) -> [[Pixel]] {
        return (0..<height).map { row in
            (0..<width).map { col in
                let offset = (width * row + col) * Pixel.bytesPerPixel
                //                print("\(row) \(col) \(offset)")
                return Pixel(offset)
            }
        }
    }
    
    func intensityFromPixelPointer(_ pointer: PixelPointer) -> [Double:UIColor] {
        let
        red   = pointer[offset + 0],
        green = pointer[offset + 1],
        blue  = pointer[offset + 2]
        guard let pixelOutput = Pixel.calculateIntensity(red, green, blue) else {
            fatalError("Error to get intensity form PixelPointer")
        }
        return pixelOutput
    }
    
    fileprivate static func calculateIntensity(_ r: UInt8, _ g: UInt8, _ b: UInt8) -> [Double:UIColor]? {
        // Normalize the pixel's grayscale value to between 0 and 1.
        // Weights from http://en.wikipedia.org/wiki/Grayscale#Luma_coding_in_video_systems
        let
        redWeight   = 0.229,
        greenWeight = 0.587,
        blueWeight  = 0.114,
        weightedMax = 255.0 * redWeight   +
            255.0 * greenWeight +
            255.0 * blueWeight,
        weightedSum = Double(r) * redWeight   +
            Double(g) * greenWeight +
            Double(b) * blueWeight

        guard let color = UIColor(named: String(format: "#%02x%02x%02x",r,g,b)) else {
            return nil
        }
        let intensity = weightedSum / weightedMax
        return [intensity:color]
    }
}
