//
//  ImportViewController.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit

class ImportViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let image = UIImage(named: "ghost_tiny") {
//            setupWithImage(image)
//        }
        
        if let image = UIImage(named: "ghost_tiny") {
            if let reader = ImagePixelReader(image: image) {
                
                //get alpha or color
                let alpha = reader.componentAt(.alpha, x: 10, y:10)
                let color = reader.colorAt(x:10, y: 10).uiColor
                
                self.view.backgroundColor = color
                self.view.alpha = CGFloat(alpha)
                
                //getting all the pixels you need
                
                var values = ""
                
                //iterate over all pixels
                for x in 0 ..< Int(image.size.width){
                    for y in 0 ..< Int(image.size.height){
                        
                        let color = reader.colorAt(x: x, y: y)
                        values += "[\(x):\(y):\(color)] "
                        
                    }
                    //add new line for every new row
                    values += "\n"
                }
                
                print(values)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupWithImage(_ image: UIImage) {
        let fixedImage = image.imageWithFixedOrientation()
        fixedImage.logPixelsOfImage()
    }
    
}
