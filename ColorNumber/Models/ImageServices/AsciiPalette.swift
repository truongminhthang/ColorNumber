    //
//  AsciiPalette.swift
//  ColorNumber
//
//  Created by Chung-Sama on 2018/01/09.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

/** Provides a list of ASCII symbols sorted from darkest to brightest. */
class AsciiPalette {
    fileprivate let font: UIFont
    
    init(font: UIFont = UIFont(name: "Menlo", size: 7)!) { self.font = font }
    
    lazy var symbols: [String] = ["1","2","3","4","5","6","7","8","9", " "]
    
    fileprivate func loadSymbols() -> [String] {
        return symbolsSortedByIntensityForAsciiCodes(0...15)  //(32...126) // from ' ' to '~'
    }
    
    fileprivate func symbolsSortedByIntensityForAsciiCodes(_ codes: CountableClosedRange<Int>) -> [String] {
        let symbols          = codes.map { self.symbolFromAsciiCode($0) },
            symbolImages     = symbols.map { UIImage.imageOfSymbol($0, self.font) },
            whitePixelCounts = symbolImages.map { self.countWhitePixelsInImage($0) },
            sortedSymbols    = sortByIntensity(symbols, whitePixelCounts)
//        print("symbolImages: \(symbolImages)")
        return sortedSymbols
    }
    /// Return a symbol code.
    fileprivate func symbolFromAsciiCode(_ code: Int) -> String {
        let symbol = code == 0 ? " " : String(code)
        return symbol//String(Character(UnicodeScalar(code)!))
    }
    
    fileprivate func countWhitePixelsInImage(_ image: UIImage) -> Int {
        let
        dataProvider = image.cgImage?.dataProvider,
        pixelData    = dataProvider?.data,
        pixelPointer = CFDataGetBytePtr(pixelData),
        byteCount    = CFDataGetLength(pixelData),
        pixelOffsets = stride(from: 0, to: byteCount, by: Pixel.bytesPerPixel)
        return pixelOffsets.reduce(0) { (count, offset) -> Int in
            let
            r = (pixelPointer?[offset + 0])! / 255,
            g = (pixelPointer?[offset + 1])! / 255,
            b = (pixelPointer?[offset + 2])! / 255,
            isWhite = (r == 1) && (g == 1) && (b == 1)
            return isWhite ? count + 1 : count
        }
    }
    
    fileprivate func sortByIntensity(_ symbols: [String], _ whitePixelCounts: [Int]) -> [String] {
        let
        mappings      = NSDictionary(objects: symbols, forKeys: whitePixelCounts as [NSCopying]),
        uniqueCounts  = Set(whitePixelCounts),
        sortedCounts  = uniqueCounts.sorted(),
        sortedSymbols = sortedCounts.map { mappings[$0] as! String }
//        print("symbols: \(symbols), mappings: \(mappings), uniqueCounts: \(uniqueCounts), sortedCounts: \(sortedCounts), sortedSymbols: \(sortedSymbols), whitePixelCounts: \(whitePixelCounts)")
        return sortedSymbols
    }
}

