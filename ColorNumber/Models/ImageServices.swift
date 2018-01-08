//
//  ImageServices.swift
//  ColorNumber
//
//  Created by Chung-Sama on 2018/01/07.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class ImageServices {
    
    static let shared: ImageServices = ImageServices()
    
    fileprivate let font: UIFont = UIFont.systemFont(ofSize: 7)
    
    fileprivate lazy var symbols: [String] = self.loadSymbols()
    
    fileprivate let maxImageSize = CGSize(width: 300, height: 300)
    
    func createSymbolAsciiMatrix(_ image: UIImage, complete: @escaping([[String]], [String]) -> Void) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            let imageProcess   = image.cropIfNeed(aspectFillToSize: self.maxImageSize) ?? image,
                        width  = Int(imageProcess.size.width),
                        height = Int(imageProcess.size.height)
            let
                dataProvider = image.cgImage?.dataProvider,
                pixelData    = dataProvider?.data,
                pixelPointer = CFDataGetBytePtr(pixelData),
                intensities  = self.intensityMatrixFromPixelPointer(pixelPointer!, width: width, height: height),
                symbolMatrix = self.symbolMatrixFromIntensityMatrix(intensities)
            DispatchQueue.main.async {
                complete(symbolMatrix, self.symbols)
            }
        }
    }
    
    
    /** Transforms an image to ASCII. */
    
    fileprivate func symbolMatrixFromIntensityMatrix(_ matrix: [[Double]]) -> [[String]] {
        return matrix.map { intensityRow in
            intensityRow.map { self.symbolFromIntensity($0) }
        }
    }
    
    fileprivate func intensityMatrixFromPixelPointer(_ pointer: PixelPointer, width: Int, height: Int) -> [[Double]] {
        let matrix = Pixel.createPixelMatrix(width, height)
        return matrix.map { pixelRow in
            pixelRow.map { pixel in
                pixel.intensityFromPixelPointer(pointer)
            }
        }
    }
    fileprivate func symbolFromIntensity(_ intensity: Double) -> String {
        assert(0.0 <= intensity && intensity <= 1.0)
        
        let factor = self.symbols.count - 1,
        value  = round(intensity * Double(factor)),
        index  = Int(value)
        return self.symbols[index]
    }
    
    /** Provides a list of ASCII symbols sorted from darkest to brightest. */
    fileprivate func loadSymbols() -> [String] {
        return symbolsSortedByIntensityForAsciiCodes(48...57) // from ' ' to '~'
    }
    fileprivate func symbolsSortedByIntensityForAsciiCodes(_ codes: CountableClosedRange<Int>) -> [String] {
        let symbols          = codes.map { self.symbolFromAsciiCode($0) },
            symbolImages     = symbols.map { UIImage.imageOfSymbol($0, self.font) },
            whitePixelCounts = symbolImages.map { self.countWhitePixelsInImage($0) },
            sortedSymbols    = sortByIntensity(symbols, whitePixelCounts)
        return sortedSymbols
    }
    fileprivate func symbolFromAsciiCode(_ code: Int) -> String {
        return String(Character(UnicodeScalar(code)!))
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
            r = pixelPointer?[offset + 0],
            g = pixelPointer?[offset + 1],
            b = pixelPointer?[offset + 2],
            isWhite = (r == 255) && (g == 255) && (b == 255)
            return isWhite ? count + 1 : count
        }
    }
    fileprivate func sortByIntensity(_ symbols: [String], _ whitePixelCounts: [Int]) -> [String] {
        let
        mappings      = NSDictionary(objects: symbols, forKeys: whitePixelCounts as [NSCopying]),
        uniqueCounts  = Set(whitePixelCounts),
        sortedCounts  = uniqueCounts.sorted(),
        sortedSymbols = sortedCounts.map { mappings[$0] as! String }
        return sortedSymbols
    }
}
