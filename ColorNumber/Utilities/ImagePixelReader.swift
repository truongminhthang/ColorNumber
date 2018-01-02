//
//  ImagePixelReader.swift
//  ColorNumber
//
//  Created by Chung Sama on 1/2/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class ImagePixelReader {
    
    enum Component:Int {
        case r = 0
        case g = 1
        case b = 2
        case alpha = 3
    }
    
    struct Color {
        var r:UInt8
        var g:UInt8
        var b:UInt8
        var a:UInt8
        
        var uiColor:UIColor {
            return UIColor(red:CGFloat(r)/255.0,green:CGFloat(g)/255.0,blue:CGFloat(b)/255.0,alpha:CGFloat(a)/255.0)
        }
        
    }
    
    let image:UIImage
    
    private var data:CFData
    private let pointer:UnsafePointer<UInt8>
    private let scale:Int
    
    init?(image:UIImage){
        
        self.image = image
        guard let cfdata = self.image.cgImage?.dataProvider?.data,
            let pointer = CFDataGetBytePtr(cfdata) else {
                return nil
        }
        self.scale = Int(image.scale)
        self.data = cfdata
        self.pointer = pointer
    }
    
    func componentAt(_ component:Component,x:Int,y:Int)->UInt8{
        
        assert(CGFloat(x) < image.size.width)
        assert(CGFloat(y) < image.size.height)
        
        let pixelPosition = (Int(image.size.width) * y * scale + x) * 4 * scale
        
        return pointer[pixelPosition + component.rawValue]
    }
    
    func colorAt(x:Int,y:Int)->Color{
        
        assert(CGFloat(x) < image.size.width)
        assert(CGFloat(y) < image.size.height)
        
        let pixelPosition = (Int(image.size.width) * y * scale + x) * 4 * scale
        
        return Color(r: pointer[pixelPosition + Component.r.rawValue],
                     g: pointer[pixelPosition + Component.g.rawValue],
                     b: pointer[pixelPosition + Component.b.rawValue],
                     a: pointer[pixelPosition + Component.alpha.rawValue])
    }
}
