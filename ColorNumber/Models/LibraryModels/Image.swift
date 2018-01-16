//
//  Image.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/15/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

struct Color {
    
}



struct MapIntensityColor {
    var count : CGFloat = 0
    var color: UIColor = UIColor(red:1, green: 1, blue: 1, alpha: 1)
    var totalRedColor: CGFloat = 0
    var totalBlueColor: CGFloat = 0
    var totalGreenColor: CGFloat = 0
    mutating func addColor (red: UInt8, green: UInt8, blue: UInt8) {
        count += 1
        totalRedColor += CGFloat(red)
        totalGreenColor += CGFloat(green)
        totalBlueColor += CGFloat(blue)
        color = UIColor(red: totalRedColor  / (count * 255), green: totalGreenColor  / (count * 255), blue: totalBlueColor / (count * 255), alpha: 1)
    }
}



class PixelImageView : UIView {
    var isEdited = false
    var colorView: UIView = UIView()
    var numberView: UIView = UIView()
    var image : UIImage
    var width: Int
    var height: Int
    var patternColors = [UIColor](repeating: UIColor.white, count: 11)
    subscript (rowIndex: Int, heightIndex:Int) -> Pixel {
        return pixelsNumber[rowIndex][heightIndex]
    }
    var pixelsNumber : [[Pixel]] = []
    var pixelColor: [[Pixel]] = []
    
    var zoomScaleForRemovingColor : CGFloat = 0.5
    var zoomScaleForRemovingTextLabel: CGFloat = 0.8
    
    // Zoom in - Zoom out logic
    var actualScalingParamter : CGFloat = 0 {
        didSet {
            if actualScalingParamter > zoomScaleForRemovingColor && oldValue < actualScalingParamter {
                // occur When zoom in
                colorView.alpha = 1 - (actualScalingParamter - zoomScaleForRemovingColor)
                numberView.alpha = (actualScalingParamter - zoomScaleForRemovingColor)
                isUserInteractionEnabled = true
            }
            else if actualScalingParamter > zoomScaleForRemovingColor && oldValue > actualScalingParamter {
                // occurt when zoom out
                colorView.alpha = 1 - (actualScalingParamter - zoomScaleForRemovingColor)
                numberView.alpha = (actualScalingParamter - zoomScaleForRemovingColor)
            }
            else if actualScalingParamter <= zoomScaleForRemovingColor {
                // occurt when normal
                colorView.alpha = 1
                numberView.alpha = 0
                isUserInteractionEnabled = false
            }
            
            
        }
    }
    init(image: UIImage) {
        self.image = image
        self.width = Int(image.size.width)
        self.height = Int(image.size.height)
        let width = (image.size.width) * Pixel.size.width
        let height = (image.size.height) * Pixel.size.height
        let imageSize = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        super.init(frame: imageSize)
        setupSubview()
        createPixelMatrix()
        setupGesture()
    }
    
    func createPixelMatrix() {
        let dataProvider = image.cgImage?.dataProvider
        let pixelData    = dataProvider?.data
        let pixelPointer = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = 4
        for row in (0..<self.height) {
            pixelsNumber.append([])
            pixelColor.append([])
            for col in (0..<self.width) {
                let offset = ((self.width * row) + col) * bytesPerPixel
                let numberPixel = Pixel(pointer: pixelPointer!, offset: offset, row: row,  col: col, type: .number)
                numberView.addSubview(numberPixel)
                colorView.addSubview(numberPixel.copy())
                pixelsNumber[row].append(numberPixel)
                pixelColor[row].append(numberPixel.copy())
                
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubview() {
        colorView.frame = self.bounds
        numberView.frame = self.bounds
        self.addSubview(colorView)
        self.insertSubview(numberView, aboveSubview: colorView)
    }
    
    private func setupGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tapGestureRecognizer.delegate = self
        addGestureRecognizer(tapGestureRecognizer)
        let dragGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleDrag(sender:)))
        dragGestureRecognizer.minimumPressDuration = 0.25
        addGestureRecognizer(dragGestureRecognizer)
    }
    
    
    @objc private func handleTap(sender: UIGestureRecognizer) {
        self.draw(atPoint: sender.location(in: self))
    }
    
    @objc private func handleDrag(sender: UIGestureRecognizer) {
        switch sender.state {
        case .changed, .began:
            self.draw(atPoint: sender.location(in: self))
        default: break
        }
    }
    private func draw(atPoint point: CGPoint) {
        let y = Int(point.y / Pixel.size.height)
        let x = Int(point.x / Pixel.size.width)
        guard x < self.pixelsNumber[0].count && y < self.pixelsNumber.count && y >= 0 && x >= 0 else { return }
        pixelsNumber[y][x].backgroundColor = UIColor.red
        pixelColor[y][x].backgroundColor = UIColor.red
    }
}

extension PixelImageView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
