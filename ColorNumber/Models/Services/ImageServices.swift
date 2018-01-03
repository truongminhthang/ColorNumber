//
//  ImageServices.swift
//  ColorNumber
//
//  Created by Chung on 1/3/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class ImageServices {
    static let shared: ImageServices = ImageServices()
    func setupWithImage(_ image: UIImage) {
        let fixedImage = image.imageWithFixedOrientation()
        fixedImage.logPixelsOfImage()
    }
    func getPixel() {
        if let image = UIImage(named: "ghost_tiny") {
            if let reader = ImagePixelReader(image: image) {
                
                //getting all the pixels you need
                
                var values = ""
                
                //iterate over all pixels
                for x in 0 ..< Int(image.size.width){
                    for y in 0 ..< Int(image.size.height){
                        
                        let color = reader.colorAt(x: x, y: y)
                        values += "[\(x):\(y):\(color)] "
                        
                    }
                    //add new line for every new row
                    values += "\n"
                }
                
                print(values)
            }
        }
    }
}
