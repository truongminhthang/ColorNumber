//
//  Image.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/15/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class PixelImageView : UIView{
    private let maxImageSize = CGSize(width: 50, height: 50)
    var colorView: UIView = UIView()
    var numberView: UIView = UIView()
    private let sizeInt: (width: Int, height: Int)
    var image : UIImage
    var currentImage: UIImage?
    var categoryID : Int
    var patternColors : [MapIntensityColor] = {
        return (0...10).map{index in
            MapIntensityColor(order: index)
        }
    }()
    subscript (rowIndex: Int, heightIndex:Int) -> Pixel {
        return pixelsNumber[rowIndex][heightIndex]
    }
    private var _pixelsNumber : [[Pixel]]?
    var pixelColor: [[Pixel]] = []
    var pixelsNumber: [[Pixel]] {
        set {
            _pixelsNumber = newValue
        }
        get {
            if _pixelsNumber == nil {
                updatePixels()
            }
            return _pixelsNumber ?? []
        }
    }
    
    func updatePixels() {
        _pixelsNumber = []
        pixelColor = []
        let dataProvider = image.cgImage?.dataProvider
        let pixelData    = dataProvider?.data
        let pixelPointer = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = 4
        for row in (0..<self.sizeInt.height) {
            pixelsNumber.append([])
            pixelColor.append([])
            for col in (0..<self.sizeInt.width) {
                let offset = ((self.sizeInt.width * row) + col) * bytesPerPixel
                let coordinate = Coordinate(col: col, row: row)
                let numberPixel = Pixel(pointer: pixelPointer!, offset: offset, coordinate: coordinate, type: .number)
                let colorPixel = numberPixel.makeDuplicate()
                AppDelegate.shared.arrangePatternColor(pixel: numberPixel)
                AppDelegate.shared.arrangePatternColor(pixel: colorPixel)
                numberView.addSubview(numberPixel)
                colorView.addSubview(colorPixel)
                pixelsNumber[row].append(numberPixel)
                pixelColor[row].append(colorPixel)
                
            }
        }
        NotificationCenter.default.post(name: .didUpdatePixel, object: nil)
        
    }

    
    var zoomScaleForRemovingColor : CGFloat = 0.5
    
    private var _selectedColorNumber : Int? {
        didSet {
            patternColors.forEach{$0.isEmpharse = false}
            guard _selectedColorNumber != nil else {return}
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
    init(image: UIImage, categoryID: Int) {
        self.categoryID = categoryID
        self.sizeInt = (Int(image.size.width), Int(image.size.height))
        let width = (image.size.width) * Pixel.size.width
        let height = (image.size.height) * Pixel.size.height
        let imageSize = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        
        // Process Image before using
        // Rotate first because the orientation is lost when resizing.
        
        let rotatedImage = image.imageWithFixedOrientation()
        let resizedImage = rotatedImage.cropImageIfNeed(maxImageSize)
        self.image = resizedImage

        super.init(frame: imageSize)
        AppDelegate.shared.patternColors = patternColors
        setupSubview()
        setupGesture()
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
        dragGestureRecognizer.minimumPressDuration = 0.15
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
