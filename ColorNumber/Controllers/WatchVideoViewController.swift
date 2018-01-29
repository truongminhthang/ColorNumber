//
//  WatchVideoViewController.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//
import UIKit
import AVKit
import Photos

class WatchVideoViewController: UIViewController, VideoExportServiceDelegate {
    @IBOutlet weak var container: UIView!
    let pixelImageView = DataService.share.selectedImage
    var duration = 0.05
    var numberOfColumn :CGFloat = 0.0
    var numberOfRow : CGFloat = 0.0
    
    
    var playerViewController: AVPlayerViewController?
    let documentsDirectoryURL : URL = {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! as String
        return  URL(fileURLWithPath: path)
    }()

    
    var localBlankVideoPath: URL {
        get {
            return documentsDirectoryURL.appendingPathComponent("video").appendingPathExtension("mp4")
        }
    }
    
    var videoID = NSUUID().uuidString
    
    var localVideoPath: URL {
        get {
            return documentsDirectoryURL.appendingPathComponent("\(videoID)").appendingPathExtension("mp4")
        }
    }
    
    let videoService = VideoService()
    let videoExportService = VideoExportService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let pixelView = pixelImageView else {return}
        // Do any additional setup after loading the view, typically from a nib.
        videoExportService.delegate = self
        numberOfColumn = pixelView.croppedImage.size.width
        numberOfRow = pixelView.croppedImage.size.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let isWidthGreaterThanHeight =  numberOfColumn > numberOfRow
        let pixelWidthHeight = container.frame.size.width / (isWidthGreaterThanHeight ? numberOfColumn : numberOfRow)
        PixelModel.size = CGSize(width: pixelWidthHeight, height: pixelWidthHeight)

        if isWidthGreaterThanHeight {
            // Move down
            let videoHeight = container.frame.size.width
            let deltaY = (videoHeight - (pixelWidthHeight * numberOfRow)) / 2
            PixelAnatomic.offSet = UIOffset(horizontal: 0, vertical: deltaY)
        } else {
            // Move Right
            let videoWidth = container.frame.size.width
            let deltaX = (videoWidth - pixelWidthHeight * numberOfColumn) / 2
            PixelAnatomic.offSet = UIOffset(horizontal: deltaX, vertical: 0)
        }
        play()
    }
    
    @IBAction func fill() {
        guard let pixelView = pixelImageView else {return}
        let endingTime = 2.5
        
        videoService.makeBlankVideo(blankImage: #imageLiteral(resourceName: "whiteBg"), videoSize: container.bounds.size, outputPath: localBlankVideoPath, duration: duration * Double(pixelView.pixelStack.count) + endingTime) { () -> Void in
            print("localBlankVideoPath : \(self.localBlankVideoPath)")
            self.exportVideo()
        }
    }
    @IBAction func play() {
        if container.layer.sublayers != nil {
            for layer in container.layer.sublayers! {
                layer.removeFromSuperlayer()
            }
        }
        let layer = createLayerAnimation(forExport: false)
        container.layer.addSublayer(layer)
    }
    
    //MARK: share Video
    @IBAction func shareVideoService(_ sender: UIButton) {
        let videoToShare = [videoService]
        let activityViewController = UIActivityViewController(activityItems: videoToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        // services no use
//        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook]
        self.present(activityViewController, animated: true, completion: nil)
    }
    

    //MARK: Save video to library
    @IBAction func saveVideoLibrary(_ sender: UIButton) {

        PHPhotoLibrary.shared().performChanges({
            // Anh xem phần atFileURL giup em
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.localVideoPath)
        }) { saved, error in
            if saved {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

                // After uploading we fetch the PHAsset for most recent video and then get its current location url
                let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions).lastObject
                PHImageManager().requestAVAsset(forVideo: fetchResult!, options: nil, resultHandler: { (avurlAsset, audioMix, dict) in
                    let newObj = avurlAsset as! AVURLAsset
                    print(newObj.url)
                    // This is the URL we need now to access the video from gallery directly.
                })
            }
        }
        
        // Set image url asset library image camera
//        func saveVideo(videoURL: URL, completion: @escaping (String) -> Void) {
//            var placeHolder: PHObjectPlaceholder? = nil
//            PHPhotoLibrary.shared().performChanges({
//                let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.localVideoPath)
//                placeHolder = creationRequest?.placeholderForCreatedAsset!
//            }, completionHandler: { success, error in
//                guard success, let placeholder = placeHolder else {
//                    return
//                }
//                let localID = placeholder.localIdentifier
//                let assetID = localID.replacingOccurrences(of: "/.*", with: "", options: [.regularExpression], range: nil)
//                let ext = "mp4"
//                let assetURLStr = "assets-library://asset/asset.\(ext)?id=\(assetID)&ext=\(ext)"
//                completion(assetURLStr)
//            })
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLayerAnimation(startTime: Double = CACurrentMediaTime(), forExport: Bool) -> CALayer {
        let parentLayer = CALayer()
        let pixelView = pixelImageView!
        let indexsItem = pixelView.pixelStack
        for (index,coordinate) in indexsItem.enumerated() {
            let layer = CALayer()
            layer.backgroundColor = DataService.share.selectedImage!.patternColors[pixelView.pixelStack[index].fillColorNumber ?? 0].color.uiColor.cgColor
            layer.opacity = 0
            layer.frame = CGRect(origin: forExport ? coordinate.originVideo : coordinate.originPoint , size: PixelModel.size)
            let triggerTime = Double(index) * duration + startTime
            let animation = displayAnimation(beginTime: triggerTime)
            layer.add(animation, forKey: "opacity")
            parentLayer.addSublayer(layer)
        }
        return parentLayer
    }
    
    
    func exportVideo() {
        let input = VideoExportInput()
        videoID = NSUUID().uuidString
        input.videoPath = self.localVideoPath
        
        let asset = AVAsset(url: self.localBlankVideoPath)
        input.videoAsset = asset
        DispatchQueue.main.async {
            input.videoFrame = self.container.bounds
            input.range = CMTimeRangeMake(kCMTimeZero, asset.duration)
            let layer = self.createLayerAnimation(startTime: AVCoreAnimationBeginTimeAtZero, forExport: true)
            input.animationLayer = layer
            self.videoExportService.exportVideoWithInput(input: input)
        }
    }
    
    func displayAnimation(beginTime: Double) -> CAAnimation {
        let animation = CABasicAnimation()
        animation.keyPath = "opacity"
        animation.fromValue = 0
        animation.toValue = 1
        animation.fillMode = kCAFillModeForwards
        animation.duration = 0
        animation.beginTime = beginTime
        animation.repeatCount = 0
        animation.isRemovedOnCompletion = false
        return animation
    }
    private func playVideo() {
        let url = self.localVideoPath
        let player = AVPlayer(url: url)
        self.playerViewController = AVPlayerViewController()
        self.playerViewController!.player = player
        self.present(self.playerViewController!, animated: true) {
            self.playerViewController!.player!.play()
        }
    }
    
    func videoExportServiceExportSuccess() {
        print("sucess")
        DispatchQueue.main.async {
            self.playVideo()
        }
    }
    
    func videoExportServiceExportFailedWithError(error: NSError) {
        print(error)
    }
    
    func videoExportServiceExportProgress(progress: Float) {
        
    }
}

