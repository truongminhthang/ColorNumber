//
//  Image.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/15/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class PixelEntity {
    var image = UIImage()
    var pixelStack : [PixelAnatomic] = []
}

class PixelImageView : UIView {
    static let maxImageSize = CGSize(width: 50, height: 50)
    var id :String? = UUID().uuidString
    var categoryID : String?
    var isEdited = false
    var image : UIImage
    var croppedImage =  UIImage()
    var captureImage: UIImage?
    var displayImage : UIImage {
        get {
            return captureImage ?? image
        }
    }
    var patternColors : [MapIntensityColor] = {
        return (0..<PixelModel.intensityToDisable).map{index in
            MapIntensityColor(order: index)
        }
    }()
    subscript (rowIndex: Int, heightIndex:Int) -> PixelModel {
        return pixelModels[rowIndex][heightIndex]
    }
    var isLoading: Bool = false
    var colorView: UIView = UIView()
    var numberView: UIView = UIView()
    var pixelModels: [[PixelModel]] = []
    var pixelStack: [PixelAnatomic] = [] {
        didSet {
            if isLoading == false {
                saveEntity()
            }
        }
    }
    
    var zoomScaleForRemovingColor : CGFloat = 0.5
    var zoomScaleForRemovingTextLabel: CGFloat = 0.8
    
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
                if value >= 0 && value < patternColors.count {
                    _selectedColorNumber = newValue
                }
                if isEdited == false {
                    isEdited = true
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
    init(image: UIImage, categoryID: String = "") {
        self.image = image
        self.categoryID = categoryID
        super.init(frame: .zero)
        setupSubview()
        setupGesture()
    }
    
    func capture() {
        _selectedColorNumber = nil
        colorView.alpha = 0.7
        colorView.frame = self.bounds
        numberView.alpha = 0
        captureImage = UIImage(view: colorView)
        saveEntity()
    }
    
    func createPixelMatrixIfNeed() {
        guard pixelModels.count == 0 else { return }
        let rotatedImage = image.imageWithFixedOrientation() // Rotate first because the orientation is lost when resizing.
        croppedImage = rotatedImage.cropImageIfNeed(PixelImageView.maxImageSize)
        
        let width = (croppedImage.size.width) * PixelModel.size.width
        let height = (croppedImage.size.height) * PixelModel.size.height
        frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        
        let dataProvider = croppedImage.cgImage?.dataProvider
        let pixelData    = dataProvider?.data
        let pixelPointer = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = 4
        pixelModels = []
        for row in (0..<Int(croppedImage.size.height)) {
            pixelModels.append([])
            for col in (0..<Int(croppedImage.size.width)) {
                let offset = ((Int(self.croppedImage.size.width) * row) + col) * bytesPerPixel
                let pixelAnatomic = PixelAnatomic(col: col, row: row)
                let pixelModel = PixelModel(pointer: pixelPointer!, offset: offset, pixelAnatomic: pixelAnatomic)
                AppDelegate.shared.arrangePatternColor(pixel: pixelModel)
                numberView.addSubview(pixelModel.numberLabel)
                colorView.addSubview(pixelModel.colorLabel)
                pixelModels[row].append(pixelModel)
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
        let y = Int(point.y / PixelModel.size.height)
        let x = Int(point.x / PixelModel.size.width)
        guard x < self.pixelModels[0].count && y < self.pixelModels.count && y >= 0 && x >= 0 else { return }
        pixelModels[y][x].fillColorNumber = selectedColorNumber
    }
}

extension PixelImageView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

