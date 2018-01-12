//
//  WatchVideoViewController.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit

class WatchVideoViewController: UIViewController {
    
    static var instance : WatchVideoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "WatchVideoViewController") as! WatchVideoViewController
    }
    
    var images = ["img_001", "img_002", "img_003", "img_004"]
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageTutorial: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnContinue: UIButton!
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 4, height: self.scrollView.frame.height)
        scrollView.delegate = self
        pageControl.currentPage = 0
    }
    @IBAction func continueAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
extension WatchVideoViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage)
        if Int(currentPage) == 3 {
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.btnContinue.isHidden = false
            })
        } else {
            self.btnContinue.isHidden = true
        }
        // Change the text accordingly
        switch Int(currentPage) {
        case 1:
            imageTutorial.image = UIImage(named: images[1])
        case 2:
            imageTutorial.image = UIImage(named: images[2])
        case 3:
            imageTutorial.image = UIImage(named: images[3])
        default:
            imageTutorial.image = UIImage(named: images[0])
        }
    }
}
