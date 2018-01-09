//
//  DetailImageController.swift
//  ColorNumber
//
//  Created by Chung-Sama on 2018/01/07.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class DetailImageController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    fileprivate let labelFont = UIFont(name: "Menlo", size: 7)!
    fileprivate let maxImageSize = CGSize(width: 200, height: 200)
    fileprivate lazy var palette: AsciiPalette = AsciiPalette(font: self.labelFont)
    fileprivate var currentView: Canvas?
    
    var pixels = Array<Array<UILabel>>()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        displayImageNamed("kermit")
    }
    
    // MARK: - Rendering
    
    fileprivate func displayImageNamed(_ imageName: String) {
        let image = UIImage(named: imageName)!
        configureZoomSupport()
        displayImage(image)
    }
    
    fileprivate func displayImage(_ image: UIImage) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            
            let // Rotate first because the orientation is lost when resizing.
            rotatedImage = image.imageWithFixedOrientation(),
            resizedImage = rotatedImage.imageConstrainedToMaxSize(self.maxImageSize),
            asciiArtist  = AsciiArtist(resizedImage, self.palette),
            symbolsMatix = asciiArtist.createAsciiArt()
            
            DispatchQueue.main.async {
                self.displayAsciiArt(symbolsMatix)
            }
        }
    }
    
    fileprivate func displayAsciiArt(_ matrix: [[String]]) {
        self.currentView?.removeFromSuperview()
        self.currentView = Canvas(itemSize: 10, symbolsMatix: matrix)
        self.scrollView.addSubview(currentView!)
        self.scrollView.contentSize = self.currentView!.frame.size
        self.updateZoomSettings(animated: true)
    }
    // MARK: - Zooming support
    
    fileprivate func configureZoomSupport() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = 5
    }
    
    fileprivate func updateZoomSettings(animated: Bool) {
        let
        scrollSize  = scrollView.frame.size,
        contentSize = scrollView.contentSize,
        scaleWidth  = scrollSize.width / contentSize.width,
        scaleHeight = scrollSize.height / contentSize.height,
        scale       = min(scaleWidth, scaleHeight)
        scrollView.minimumZoomScale = scale/2
        scrollView.setZoomScale(scale, animated: animated)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        setCenterScrollView(scrollView, currentView)
        return currentView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let subView = scrollView.subviews[0]
        setCenterScrollView(scrollView, subView)
    }
    
    func setCenterScrollView(_ scrollView: UIScrollView,_ subView: UIView?) {
        let offsetX = max(Double(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5,0.0)
        let offsetY = max(Double(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5,0.0)
        // adjust the center of view
        subView!.center = CGPoint(x: scrollView.contentSize.width * 0.5 + CGFloat(offsetX),y: scrollView.contentSize.height * 0.5 + CGFloat(offsetY))
    }
}

