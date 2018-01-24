//
//  VideoServices.swift
//  MGAnimation
//
//  Created by Admin on 1/18/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import CoreGraphics

class VideoService: NSObject {
    func makeBlankVideo(blankImage: UIImage, videoSize: CGSize, outputPath: URL, duration: Double, complete: @escaping () -> Void) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: outputPath)
        } catch {
            print(error.localizedDescription)
        }
        
        let fps: Double = 30
        
        // Start building video from defined frames
        do {
            let videoWriter = try AVAssetWriter(url: outputPath, fileType: AVFileType.mp4)
            var videoSettings: [String : Any]
            if #available(iOS 11.0, *) {
                videoSettings  = [AVVideoCodecKey : AVVideoCodecType.h264,
                                                     AVVideoWidthKey: videoSize.width,
                                                     AVVideoHeightKey: videoSize.height]
            } else {
                // Fallback on earlier versions
                videoSettings = [AVVideoCodecKey : AVVideoCodecH264,
                                                     AVVideoWidthKey: videoSize.width,
                                                     AVVideoHeightKey: videoSize.height]
            }
            
            let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
            let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: nil)
            videoWriterInput.expectsMediaDataInRealTime =  true
            videoWriter.add(videoWriterInput)
            
            // Start a session:
            videoWriter.startWriting()
            videoWriter.startSession(atSourceTime: kCMTimeZero)
            
            
            let buffer: CVPixelBuffer = pixelBufferFromCGImage(image: blankImage.cgImage!)
            
            var appendOK = true
            var i: Double = 0
            while appendOK && i < duration {
                if adaptor.assetWriterInput.isReadyForMoreMediaData {
                    let frameTime = CMTimeMake(Int64(i*fps), Int32(fps))
                    appendOK = adaptor.append(buffer, withPresentationTime: frameTime)
                    if !appendOK {
                        print("append error")
                    }
                }
                else {
                    print("adapter not ready")
                    Thread.sleep(forTimeInterval: 0.1)
                }
                i += duration/2
            }
            videoWriterInput.markAsFinished()
            videoWriter.finishWriting(completionHandler: { () -> Void in
                complete()
            })
        } catch {
            print("AVAssetWriter error")
        }
    }
    
    private func pixelBufferFromCGImage(image: CGImage) -> CVPixelBuffer {
        let size = UIImage(cgImage: image).size
        let options: Dictionary = [ kCVPixelBufferCGImageCompatibilityKey as String : NSNumber(value: true),
                                    kCVPixelBufferCGBitmapContextCompatibilityKey as String : NSNumber(value: true) ]
        var pxbuffer: CVPixelBuffer?
        let _ = CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height), kCVPixelFormatType_32ARGB, options as CFDictionary, &pxbuffer)
        
        CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pxdata = CVPixelBufferGetBaseAddress(pxbuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(data: pxdata, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(size.width), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        context!.concatenate(CGAffineTransform(rotationAngle: 0))
        context?.draw(image, in: CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height)))
        
        CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0));
        return pxbuffer!
    }
}
