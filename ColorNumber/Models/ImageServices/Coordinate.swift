//
//  Coordinate.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/17/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

public class PixelAnatomic: NSObject, NSCoding {
    var col: Int
    var row: Int
    var fillColorNumber: Int?
    static var offSet = UIOffset.zero
    var originPoint: CGPoint {
        return CGPoint(x: CGFloat(col) * PixelModel.size.width +  PixelAnatomic.offSet.horizontal, y: CGFloat(row) * PixelModel.size.height + PixelAnatomic.offSet.vertical)
    }
    var originVideo: CGPoint {
        return CGPoint(x: CGFloat(col) * PixelModel.size.width + PixelAnatomic.offSet.horizontal , y: UIScreen.main.bounds.size.width - (CGFloat(row) + 1) * PixelModel.size.height - PixelAnatomic.offSet.vertical)
    }
    struct Key {
        static let col = "col"
        static let row = "row"
        static let fillColorNumber = "fillColorNumber"

    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(col, forKey: Key.col)
        aCoder.encode(row, forKey: Key.row)
        aCoder.encode(fillColorNumber, forKey: Key.fillColorNumber)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.col = aDecoder.decodeInteger(forKey: Key.col)
        self.row = aDecoder.decodeInteger(forKey: Key.row)
        self.fillColorNumber = aDecoder.decodeObject(forKey: Key.fillColorNumber) as? Int
        
    }
    
    init(col: Int, row: Int) {
        self.col = col
        self.row = row
    }
    
    func makeCopy() -> PixelAnatomic {
        let result = PixelAnatomic(col: col, row: row)
        result.fillColorNumber = fillColorNumber
        return result
    }
    
}

