//
//  MapIntensityColor.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/17/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class MapIntensityColor {
 
    var colorOrder: Int
    var count : CGFloat = 0 {
        didSet {
            if count == 0 {
                NotificationCenter.default.post(name: .fillColorDone, object: colorOrder)
                checkIfCompleteGame()
            } else {
                NotificationCenter.default.post(name: .fillColorNotDone, object: colorOrder)
            }
        }
    }

    var color: Color = Color()
    var totalRedColor: CGFloat = 0
    var totalBlueColor: CGFloat = 0
    var totalGreenColor: CGFloat = 0
    var isEmpharse = false {
        didSet {
            guard isEmpharse != oldValue else { return }
            pixels.forEach{$0.isEmpharse = isEmpharse}
        }
    }
    var pixels : [Pixel] = []
    func addFixel(_ pixel: Pixel) {
        guard pixel.intensityNumber == colorOrder else { return }
        count += 1
        let color = pixel.color
        totalRedColor += color.red
        totalGreenColor += color.green
        totalBlueColor += color.blue
        pixels.append(pixel)
        self.color = Color(red: totalRedColor / count, green: totalGreenColor / count, blue: totalBlueColor / count)
    }
    
    init(order: Int) {
        colorOrder = order
    }
    
    func checkIfCompleteGame(){
        var isComplete = true
        for  patternColor in AppDelegate.shared.patternColors {
            if patternColor.count != 0 {
                isComplete = false
            }
        }
        if isComplete {
            NotificationCenter.default.post(name: .gameCompleted, object: nil)
        }
    }
    
}
