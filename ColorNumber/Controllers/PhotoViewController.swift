
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
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var cancelButton: UIButton!

    var imageTaken: UIImage?
    var monoFilterName: String = "CIPhotoEffectMono"
    var pixelFilterName: String = "CIPixellate"
    var scale: Int?
    var fakeLayer: CALayer?
    var monoLayer: CALayer?
    var layerView: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageView.image = imageTaken
        imageView.image = filterImage(image: imageTaken!, scale: scale!)
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func filterImage(image: UIImage, scale: Int) -> UIImage {
        var resultImage = imageTaken
        let softwareContext = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        var imageToDisplay: CIImage? = imageTaken?.ciImage
        if let pixelFilter = CIFilter(name: pixelFilterName) {
            if let ciImage = resultImage?.ciImage {
                pixelFilter.setValue(ciImage, forKey: kCIInputImageKey)
                pixelFilter.setValue(scale, forKey: "inputScale")
            } else {
                pixelFilter.setValue(CIImage(image: resultImage!), forKey: kCIInputImageKey)
                pixelFilter.setValue(scale, forKey: "inputScale")
  
            }
            imageToDisplay = pixelFilter.outputImage
        }
        
        if let monoFilter = CIFilter(name: monoFilterName) {
            if let ciImage = imageToDisplay {
                monoFilter.setValue(ciImage, forKey: kCIInputImageKey)
            } else {
                monoFilter.setValue(CIImage(image: resultImage!), forKey: kCIInputImageKey)
            }
            imageToDisplay = monoFilter.outputImage

        }
        if let imageToDisplay = imageToDisplay {
            let cgImage = softwareContext.createCGImage(imageToDisplay, from: imageToDisplay.extent.integral)
            resultImage = UIImage(cgImage: cgImage!)
        }
        return resultImage!
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        let reverseValue = (Int(sender.maximumValue) - currentValue) + Int(sender.minimumValue)
        scale = reverseValue
        imageView.image = filterImage(image: imageTaken!, scale: scale!)
    }

    
}
