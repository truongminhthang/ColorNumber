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
    
    var colors = [[UIColor]]()
    // MARK: Rendering
    func renderingImage(_ image: UIImage, complete: @escaping ([PixelState], Int, Int) -> Void) {
        let row = Int(image.size.width)
        let column = Int(image.size.height)
        var pixelsState: [PixelState] = []
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            guard let imagePixelReader = ImagePixelReader(image: image) else { return }
            //iterate over all pixels
            for x in 0 ..< row {
                for y in 0 ..< column {
                    let color = imagePixelReader.colorAt(x: x, y: y)
                    let pixelState = PixelState(x: x, y: y, color: color.uiColor)
                    pixelsState.append(pixelState)
                }
            }
        }
        DispatchQueue.main.async {
            complete(pixelsState, row, column)
        }
    }
}
