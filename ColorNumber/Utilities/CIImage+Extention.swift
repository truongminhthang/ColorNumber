//
//  CIImage+Extention.swift
//  ColorNumber
//
//  Created by Chung-Sama on 2018/01/31.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

extension CIImage {
    func monoCIPixellate(with scale: Int) -> CIImage? {
        guard let ciPixellate = CIFilter(name: "CIPixellate") else { return nil}
        ciPixellate.setValue(self, forKey: "inputImage")
        ciPixellate.setValue(scale, forKey: "inputScale")
        guard let outputImageCIPixellate = ciPixellate.value(forKey: "outputImage") as? CIImage else { return nil}
        
        guard let ciPhotoEffectMono = CIFilter(name: "CIPhotoEffectMono") else { return nil}
        ciPhotoEffectMono.setValue(outputImageCIPixellate, forKey: "inputImage")
        let outputImageMono = ciPhotoEffectMono.value(forKey: "outputImage") as? CIImage
        return outputImageMono
    }
}

