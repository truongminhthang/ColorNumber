//
//  PixelGridView.swift
//  ColorNumber
//
//  Created by Thuy Truong Quang on 12/31/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import Foundation
import UIKit

class PixelGridView : UIView {
    // MARK: - Variable
    private var pixels: [Pixel] = []
    private var uniquePixels: [Pixel] = []
    public var uniquePixelCount: Int {
        get {
            return self.uniquePixels.count
        }
    }
    
    private var pixelsToLabels: Dictionary <Pixel, [UILabel]> = Dictionary <Pixel, [UILabel]> ()
    // MARK: - Function
    public func setup(with image: UIImage!) {
        self.pixels = image.pixelData()
        self.uniquePixels = Set<Pixel>(pixels).sorted()

        let originX = 0
        let originY = 0
        
        for i in 0..<Int(image.size.width) {
            for j in 0..<Int(image.size.height) {
                let thePixel = self.pixels[i * Int(image.size.width) + j]
               if thePixel.red != 0 && thePixel.green != 0 && thePixel.blue != 0 && thePixel.alpha != 0 {
                let label = UILabel(frame: CGRect(x: 50 * j + originX, y: 50 * i + originY, width: 50, height: 50))
                label.text = String(describing: self.uniquePixels.index(of: thePixel)! + 1)
                label.textAlignment = .center
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.labelWasTapped(_:)))
                label.addGestureRecognizer(tapGestureRecognizer)
                label.isUserInteractionEnabled = true
                
                /// Create the borders
                var borders = [UIView]()
                
                borders.append(UIView(frame: CGRect(x: 0, y: 0, width: label.frame.size.width, height: 0.2))) // Top
                borders.append(UIView(frame: CGRect(x: 0, y: 0, width: 0.2, height: label.frame.size.height))) // Left
                if j == Int(image.size.height) - 1 {
                    // Bottom
                    borders.append(UIView(frame: CGRect(x: 0, y: label.frame.size.height - 1, width: label.frame.size.width, height: 0.2)))
                }
                if i == Int(image.size.width) - 1{
                    // Right
                    borders.append(UIView(frame: CGRect(x: label.frame.size.width - 1, y: 0, width: 1, height: label.frame.size.height)))
                }
                
                for b in borders {
                    b.backgroundColor = UIColor.black
                    label.addSubview(b)
                }
                
                self.addSubview(label)
                self.frame.size = CGSize(width: label.frame.size.width * image.size.width, height: label.frame.size.height * image.size.height)
                // Maintain our pixels -> labels map
                if var arr = self.pixelsToLabels[thePixel] {
                    arr.append(label)
                    self.pixelsToLabels[thePixel] = arr
                } else {
                    self.pixelsToLabels[thePixel] = [label]
                }
            }
        }
    }
        //self.pixelSelected = 10
        
}
    
    @objc
    private func labelWasTapped(_ tapGestureRecognizer: UITapGestureRecognizer!) {
        var thePixel: Pixel? = nil
        
        // First find the pixel it corresponds to
        for (pixel, labels) in self.pixelsToLabels {
            if labels.contains(tapGestureRecognizer.view! as! UILabel) {
                thePixel = pixel
                break
            }
        }
        
        // Then update the currently selected pixel
       // self.pixelSelected = self.uniquePixels.index(of: thePixel!)!
    }
}
