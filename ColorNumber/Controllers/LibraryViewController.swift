//
//  LibraryViewController.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit
import StoreKit

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var addThree: UIImageView!
    @IBOutlet weak var watchVideo: UIImageView!
    @IBOutlet weak var reviewLb: DesignableLabel!
    @IBOutlet weak var feedbackLb: DesignableLabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if UserDefaults.standard.object(forKey: "Key") == nil {
            UserDefaults.standard.set(false, forKey: "Key")
        }
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup view
    func setupView() {
//        reviewLb.setFont(7, unit: 1)
//        feedbackLb.setFont(7, unit: 1)
        let tapWatchVideoImage = UITapGestureRecognizer.init(target: self, action: #selector(self.watchVideo(_:)))
        watchVideo.addGestureRecognizer(tapWatchVideoImage)
        let tapAddThree = UITapGestureRecognizer.init(target: self, action: #selector(self.addThree(_:)))
        addThree.addGestureRecognizer(tapAddThree)
        let tapReview = UITapGestureRecognizer.init(target: self, action: #selector(self.review(_:)))
        reviewLb.addGestureRecognizer(tapReview)
        let tapFeedback = UITapGestureRecognizer.init(target: self, action: #selector(self.feedback(_:)))
        feedbackLb.addGestureRecognizer(tapFeedback)
    }
    
    // MARK: Action Navigation view
    @objc func watchVideo(_ recogznier: UITapGestureRecognizer) {
        let rootVC = UIStoryboard.main.instantiateViewController(withIdentifier: "WatchVideoViewController") as! WatchVideoViewController
        watchVideo.animate { (complete) in
            if complete {
                self.present(rootVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func addThree(_ recogznier: UITapGestureRecognizer) {
        let rootVC = UIStoryboard.main.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsViewController
        watchVideo.animate { (complete) in
            if complete {
                self.present(rootVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func review(_ recogznier: UITapGestureRecognizer) {
        self.reviewLb.animate { (complete) in
            self.getUserDefault()
        }
    }
    
    @objc func feedback(_ recogznier: UITapGestureRecognizer) {
        self.feedbackLb.animate { (complete) in
            print("Feedback")
        }
    }
    
    // MARK: - ReViewApp
    private func getUserDefault() {
        if UserDefaults.standard.bool(forKey: "Key") == false {
            showReviewAlert()
        }
    }
    
    private func showReviewAlert() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/id{ID App}?action=write-review") {
            showAlertController(url: url)
        }
        
    }
    
    private func showAlertController(url: URL) {
        let alert = UIAlertController(title: "Review request",
                                      message: "We are always grateful for your help!\nPlease review！",
                                      preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: {
                                            (action:UIAlertAction!) -> Void in
                                            UserDefaults.standard.set(false, forKey: "Key")
        })
        alert.addAction(cancelAction)
        
        let reviewAction = UIAlertAction(title: "Review",
                                         style: .default,
                                         handler: {
                                            (action:UIAlertAction!) -> Void in
                                            UserDefaults.standard.set(true, forKey: "Key")
                                            if #available(iOS 10.0, *) {
                                                UIApplication.shared.open(url, options: [:])
                                            }
                                            else {
                                                UIApplication.shared.openURL(url)
                                            }
        })
        alert.addAction(reviewAction)
    }
    
}
