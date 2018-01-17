//
//  Image.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/15/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

struct Coordinate {
    var col: Int
    var row: Int
    
    var originPoint: CGPoint {
        return CGPoint(x: CGFloat(col) * Pixel.size.width, y: CGFloat(row) * Pixel.size.height)
    }
}

struct Color {
     var red: CGFloat
     var green: CGFloat
     var blue: CGFloat
    var uiColor: UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    var tranperentColor: UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 0.7)

    }
    
    init(red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    
    
}



class MapIntensityColor {
    private var colorOrder: Int
    var count : CGFloat = 0
    var color: Color = Color()
    var totalRedColor: CGFloat = 0
    var totalBlueColor: CGFloat = 0
    var totalGreenColor: CGFloat = 0
    var isEmpharse = false {
        didSet {
            guard isEmpharse != oldValue else {return}
            pixels.forEach{$0.isEmpharse = isEmpharse}
        }
    }
    var pixels : [Pixel] = []
    func addFixel(_ pixel: Pixel) {
        guard pixel.intensityNumber == colorOrder else { return }
        count += 1
        let color = pixel.color
        totalRedColor += color.red
        totalGreenColor += color.green
        totalBlueColor += color.blue
        pixels.append(pixel)
        self.color = Color(red: totalRedColor / count, green: totalGreenColor / count, blue: totalBlueColor / count)
    }
    
    init(order: Int) {
        colorOrder = order
    }
    
}

protocol PixelDelegate: class {
    func arrangePatternColor(pixel: Pixel)
    var patternColors: [MapIntensityColor] {get set}
}

class PixelImageView : UIView, PixelDelegate{

    var isEdited = false
    var colorView: UIView = UIView()
    var numberView: UIView = UIView()
    var image : UIImage
    var width: Int
    var height: Int
    var patternColors : [MapIntensityColor] = {
        return (0...10).map{index in
            MapIntensityColor(order: index)
        }
    }()
    subscript (rowIndex: Int, heightIndex:Int) -> Pixel {
        return pixelsNumber[rowIndex][heightIndex]
    }
    var pixelsNumber : [[Pixel]] = []
    var pixelColor: [[Pixel]] = []
    
    var zoomScaleForRemovingColor : CGFloat = 0.5
    var zoomScaleForRemovingTextLabel: CGFloat = 0.8
    
    var _selectedColorNumber : Int? {
        didSet {
            guard _selectedColorNumber != nil else {return}
            patternColors.forEach{$0.isEmpharse = false}
            patternColors[selectedColorNumber!].isEmpharse = true
        }
    }
    
    var selectedColorNumber: Int? {
        set {
            if let value = newValue {
                if value >= 0 && value < patternColors.count - 1 {
                    _selectedColorNumber = newValue
                }
            } else {
                _selectedColorNumber = nil

            }
        }
        get {
            return _selectedColorNumber
        }
    }
    
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
        AppDelegate.shared.patternColors = patternColors
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
                let coordinate = Coordinate(col: col, row: row)
                let numberPixel = Pixel(pointer: pixelPointer!, offset: offset, coordinate: coordinate, type: .number)
                let colorPixel = numberPixel.makeDuplicate()
                numberPixel.delegateToImage = self
                colorPixel.delegateToImage = self
                numberView.addSubview(numberPixel)
                colorView.addSubview(colorPixel)
                pixelsNumber[row].append(numberPixel)
                pixelColor[row].append(colorPixel)
                
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
    
    func arrangePatternColor(pixel: Pixel) {
        patternColors[pixel.intensityNumber].addFixel(pixel)
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
            pixelsNumber[y][x].fillColorNumber = selectedColorNumber
            pixelColor[y][x].fillColorNumber = selectedColorNumber
    }
}

extension PixelImageView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
