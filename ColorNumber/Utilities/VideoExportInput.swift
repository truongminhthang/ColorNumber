//
//  VideoExportInput.swift
//  MGAnimation
//
//  Created by Admin on 1/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AVFoundation

class VideoExportInput: NSObject {
    var videoAsset: AVAsset!
    var audioAsset: AVAsset?
    
    var range: CMTimeRange!
    var videoFrame: CGRect!
    
    var videoVolume: Float = 1
    var bgmVolume: Float = 1
    
    var videoPath: URL!
    
    var animationLayer: CALayer?
}

