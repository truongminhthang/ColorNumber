
//
//  PhotoViewController.swift
//  ColorNumber
//
//  Created by Quoc Dat on 12/29/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    var imageTaken: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageTaken
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func Exit(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
      
    }
    
}
