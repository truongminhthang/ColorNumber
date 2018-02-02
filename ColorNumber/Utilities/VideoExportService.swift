//
//  VideoExportService.swift
//  MGAnimation
//
//  Created by Admin on 1/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class VideoExportService: NSObject {
    weak var delegate: VideoExportServiceDelegate?
    private var progressTimer: Timer?
    private var exporter: AVAssetExportSession!
    private var input: VideoExportInput!
    
    func exportVideoWithInput(input: VideoExportInput) {
        self.input = input
        DispatchQueue.global(qos: .default).async {
            self.exportVideoAsync()
        }
    }
    
    private func exportVideoAsync() {
        var inputParams = [AVAudioMixInputParameters]()
        
        // 2 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        let mixComposition = AVMutableComposition()

        // 3 - Video track
        let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
        
        guard let videoAssetTrack = input.videoAsset.tracks(withMediaType: AVMediaType.video).first  else {return}
        do {
            try videoTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, input.videoAsset.duration), of: videoAssetTrack, at: kCMTimeZero)
        } catch _ {
        }
        // 3.0 - Audio track
        if let audioAsset = input.audioAsset {
            let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))
            do {
                try audioTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), of: audioAsset.tracks(withMediaType: AVMediaType.audio)[0] , at: kCMTimeZero)
            } catch _ {
            }
            let audioParams = self.audioParamsForTrack(track: audioTrack!, volume: input.bgmVolume)
            inputParams.append(audioParams)
        }
        
        // 3.1 - Create AVMutableVideoCompositionInstruction
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, input.videoAsset.duration)
        
        // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
        let videolayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack!)
        videolayerInstruction.setTransform(videoAssetTrack.preferredTransform, at: kCMTimeZero)
        videolayerInstruction.setOpacity(0.0, at: input.videoAsset.duration)
        
        // 3.3 - Add instructions
        mainInstruction.layerInstructions = [videolayerInstruction]
        let mainCompositionInst = AVMutableVideoComposition()
        let naturalSize = videoAssetTrack.naturalSize
        mainCompositionInst.renderSize = naturalSize
        mainCompositionInst.instructions = [mainInstruction]
//        print(Int32(CMTimeGetSeconds(input.videoAsset.duration)))
        mainCompositionInst.frameDuration = CMTimeMake(1, 60)
        self.applyVideoEffectsToComposition(composition: mainCompositionInst, size: naturalSize)
        
        // 4 - Get path
        let url = input.videoPath
        let audioMix = AVMutableAudioMix()
        audioMix.inputParameters = inputParams as [AVAudioMixInputParameters]
        
        // 5 - Create exporter
        exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        exporter.timeRange = input.range
        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mp4
        exporter.videoComposition = mainCompositionInst
        exporter.audioMix = audioMix
        
        DispatchQueue.main.async {
            self.progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerTick), userInfo: nil, repeats: true)
        }
        
        self.exporter.exportAsynchronously { [unowned self]() -> Void in
            self.finishExportAtFileUrl(url: url!)
        }
    }
    
    @objc func timerTick() {
        DispatchQueue.main.async {
            self.delegate?.videoExportServiceExportProgress(progress: self.exporter.progress)
        }
    }
    
    private func finishExportAtFileUrl(url: URL) {
        DispatchQueue.main.async {
            self.progressTimer?.invalidate()
            if self.exporter.status == AVAssetExportSessionStatus.completed {
                if self.input.isSaveCameraRoll {
                    self.saveVideo(videoURL: url, completion: { [unowned self] urlAssest, localIdentifier in
                        self.delegate?.videoExportServiceExportSuccess(with: urlAssest, localIdentifier: localIdentifier, and: true)
                    })
                } else {
                    self.delegate?.videoExportServiceExportSuccess(with: url, localIdentifier: "nil", and: false)
                }
            }
            else {
                self.delegate?.videoExportServiceExportFailedWithError(error: self.exporter.error! as NSError)
            }
        }
    }
    
    
    //  Save video to library image camera
    private func saveVideo(videoURL: URL, completion: @escaping (URL, String) -> Void ) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
        }) { saved, error in
            if saved {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                
                // After uploading we fetch the PHAsset for most recent video and then get its current location url
                
                let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions).lastObject
                PHImageManager().requestAVAsset(forVideo: fetchResult!, options: nil, resultHandler: { (avurlAsset, audioMix, dict) in
                    let newObj = avurlAsset as! AVURLAsset
                    let localIdentifier = fetchResult!.localIdentifier
                    // This is the URL we need now to access the video from gallery directly.
                    completion(newObj.url, localIdentifier)
                })
            }
        }
    }
    
    private func audioParamsForTrack(track: AVAssetTrack, volume: Float) -> AVAudioMixInputParameters {
        let audioInputParams = AVMutableAudioMixInputParameters(track: track)
        audioInputParams.setVolume(volume, at: kCMTimeZero)
        audioInputParams.trackID = track.trackID
        return audioInputParams.copy() as! AVAudioMixInputParameters
    }
    
    private func applyVideoEffectsToComposition(composition: AVMutableVideoComposition, size: CGSize) {
        let videoLayer = CALayer()
        videoLayer.frame = input.videoFrame
        
        let parentLayer = CALayer()
        parentLayer.frame = input.videoFrame
        parentLayer.addSublayer(videoLayer)
        if let animationLayer = input.animationLayer {
            parentLayer.addSublayer(animationLayer)
        }
        
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    }
}
