
//
//  PhotoViewController.swift
//  ColorNumber
//
//  Created by Quoc Dat on 12/29/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit
import CoreImage

class PhotoViewController: UIViewController {
    static var instance : PhotoViewController {
        let storyboard = UIStoryboard(name: "Import", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "PhotoVC") as! PhotoViewController
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var changeLevelOfDifficult: UISlider!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var imageTaken: UIImage?
    var scale = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLevelOfDifficult.value = Float(scale)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        scaleImage(scale: scale)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scaleImage(scale: Int) {
        if imageTaken != nil {
            let height = imageTaken!.size.height
            let width = imageTaken!.size.width
            let sizeCrop = width > height ? CGSize(width: height, height: height) : CGSize(width: width, height: width)
            var resultImage = imageTaken!.imageWithFixedOrientation().cropImageIfNeed(sizeCrop)
            let softwareContext = CIContext(options: [kCIContextUseSoftwareRenderer: true])
            var imageToDisplay = resultImage.ciImage
            if let pixelFilter = CIFilter(name: "CIPixellate") {
                if let ciImage = resultImage.ciImage {
                    pixelFilter.setValue(ciImage, forKey: kCIInputImageKey)
                    pixelFilter.setValue(scale, forKey: "inputScale")
                } else {
                    pixelFilter.setValue(CIImage(image: resultImage), forKey: kCIInputImageKey)
                    pixelFilter.setValue(scale, forKey: "inputScale")
                    
                }
                imageToDisplay = pixelFilter.outputImage
            }
            
            if let monoFilter = CIFilter(name: "CIPhotoEffectMono") {
                if let ciImage = imageToDisplay {
                    monoFilter.setValue(ciImage, forKey: kCIInputImageKey)
                } else {
                    monoFilter.setValue(CIImage(image: resultImage), forKey: kCIInputImageKey)
                }
                imageToDisplay = monoFilter.outputImage
                
            }
            if let imageToDisplay = imageToDisplay {
                let cgImage = softwareContext.createCGImage(imageToDisplay, from: imageToDisplay.extent.integral)
                resultImage = UIImage(cgImage: cgImage!)
            }
            imageView.image = resultImage
        }
    }
    
    func checkCropImageWithScale(image: UIImage) -> UIImage {
        let height = image.size.height
        let width = image.size.width
        let sizeCrop = width > height ? CGSize(width: height, height: height) : CGSize(width: width, height: width)
        return image.imageWithFixedOrientation().cropImageIfNeed(sizeCrop)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeLevelOfDifficult(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        let reverseValue = (Int(sender.maximumValue) - currentValue) + Int(sender.minimumValue)
        scale = reverseValue
        scaleImage(scale: scale)
    }
    @IBAction func renderingPixelImage(_ sender: UIButton) {
        let pixelImageView = PixelImageView(image: checkCropImageWithScale(image: imageTaken!))
        DataService.share.addImageCreatedByUser(pixelImage: pixelImageView)
        AppDelegate.shared.patternColors = pixelImageView.patternColors
        pixelImageView.reloadData()
        AppDelegate.shared.patternColors = AppDelegate.shared.patternColors.filter { $0.pixels.count != 0}
        performSegue(withIdentifier: "showPaintVC", sender: nil)
    }
}

