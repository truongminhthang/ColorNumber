//
//  LibraryViewController+Alert.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/29/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI

// MARK: - <#Mark#>

extension LibraryViewController {
    
    // MARK: - ReViewApp
    func getUserDefault() {
        if UserDefaults.standard.bool(forKey: "Key") == false {
            showReviewAlert()
        }
    }
    
    func showReviewAlert() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/id{ID App}?action=write-review") {
            showAlertController(url: url)
        }
        
    }
    
    func showAlertController(url: URL) {
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
    
    // MARK: Action Navigation view
    @objc func watchVideo(_ recogznier: UITapGestureRecognizer) {
       
    }
    
    @objc func addThree(_ recogznier: UITapGestureRecognizer) {
        
    }
    
    @objc func review(_ recogznier: UITapGestureRecognizer) {
        self.reviewLb.animate { (complete) in
            self.getUserDefault()
        }
    }
    
    @objc func feedback(_ recogznier: UITapGestureRecognizer) {
        self.feedbackLb.animate { (complete) in
            self.sendEmail()
        }
    }
    
}
extension LibraryViewController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["paul@hackingwithswift.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
