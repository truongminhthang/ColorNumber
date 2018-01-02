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
        if let image = UIImage(named: "ghost_tiny") {
            setupWithImage(image)
        }
        
        // Do any additional setup after loading the view.
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
