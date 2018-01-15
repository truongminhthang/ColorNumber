//
//  AsciiArtist.swift
//  ColorNumber
//
//  Created by Chung-Sama on 2018/01/09.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

/** Transforms an image to ASCII art. */
class AsciiArtist {
    fileprivate let
    image:   UIImage,
    palette: AsciiPalette
    
    init(_ image: UIImage, _ palette: AsciiPalette) {
        self.image   = image
        self.palette = palette
    }
    
    func createAsciiArt() -> [[String]] {
        let
        dataProvider = image.cgImage?.dataProvider,
        pixelData    = dataProvider?.data,
        pixelPointer = CFDataGetBytePtr(pixelData),
        intensities  = intensityMatrixFromPixelPointer(pixelPointer!),
        symbolsMatrix = matrixSymbol(intensities)
        return symbolsMatrix
    }
    
    fileprivate func intensityMatrixFromPixelPointer(_ pointer: PixelPointer) -> [Double:UIColor] {
        let
        width  = Int(image.size.width),
        height = Int(image.size.height),
        matrix = Pixel.createPixelMatrix(width, height)
        return [:]

        
//        return matrix.map { pixelRow in
//            pixelRow.map { pixel in
//                pixel.intensityFromPixelPointer(pointer)
//            }
//        }
    }
    
    fileprivate func matrixSymbol(_ matrix: [Double:UIColor]) -> [[String]] {
        return matrix.map { intensityRow in
            print(intensityRow)
           // intensityRow.map { self.symbolFromIntensity($0) }
            return [""]
        }
    }
    
    fileprivate func symbolFromIntensity(_ intensity: Double) -> String {
        assert(0.0 <= intensity && intensity <= 1.0)
//        print(intensity)
        let factor = palette.symbols.count - 1,
        value  = round(intensity * Double(factor)),
        index  = Int(value)
        print(palette.symbols)
        return palette.symbols[index]
    }
}
