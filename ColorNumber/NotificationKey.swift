//
//  NotificationKey.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/17/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let fillColorDone                 = Notification.Name("fillColorDone")
    static let fillColorNotDone                 = Notification.Name("fillColorNotDone")
    static let gameCompleted                 = Notification.Name("gameCompleted")
    static let loadSampleComplete                 = Notification.Name("loadSampleComplete")
    static let updateEditedImages              = Notification.Name("updateEditedImages")
    static let showTabBar              = Notification.Name("showTabBar")
    static let hideTabBar              = Notification.Name("hideTabBar")
    static let backToHome              = Notification.Name("backToHome")


    


}

func showAlert(vc: UIViewController, title:String, message: String) {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in}
    
    alertController.addAction(okAction)
    
    vc.present(alertController, animated: true, completion: nil)
}
