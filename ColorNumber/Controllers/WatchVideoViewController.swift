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
    @IBOutlet weak var saveCameraRollButton: UIButton!
    @IBOutlet weak var shareInstagramButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    let pixelImageView = DataService.share.selectedImage
    var duration = 0.025
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
    
    @IBAction func play() {
        if container.layer.sublayers != nil {
            for layer in container.layer.sublayers! {
                layer.removeFromSuperlayer()
            }
        }
        let layer = createLayerAnimation(forExport: false)
        container.layer.addSublayer(layer)
    }
    
    //MARK: More
    @IBAction func more(_ sender: UIButton) {
        moreButton.animate { [unowned self] sucess in
            self.saveVideo(isSaveCameraRoll: false)
            self.moreButton.isEnabled = false
        }
    }
    
    //MARK: Save Instagram
    var isShareInstagram: Bool = false
    @IBAction func shareInstagram(_ sender: UIButton) {
        isShareInstagram = true
        shareInstagramButton.animate { [unowned self] sucess in
            self.shareInstagramButton.isEnabled = false
            self.saveVideo(isSaveCameraRoll: true)
        }
    }
    
    //MARK: Save video to library
    @IBAction func saveVideoLibrary(_ sender: UIButton) {
        saveCameraRollButton.animate { [unowned self] sucess in
            self.saveCameraRollButton.isEnabled = false
            self.saveVideo(isSaveCameraRoll: true)
        }
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
    
    
    func shareVideo(with url: URL) {
        let activityItems = [url]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.popoverPresentationController?.sourceRect = self.view.frame
        // services no use
        activityViewController.excludedActivityTypes = [ .postToTwitter, .postToFacebook, .airDrop , .postToWeibo]
        moreButton.isEnabled = true
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func shareInstagram(with url: URL) {
        let caption = "Đăng lên Instagram"
        let instagramString = "instagram://library?AssetPath=\(url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)&InstagramCaption=\(caption.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)"
        let instagramURL = URL(string: instagramString)

        if UIApplication.shared.canOpenURL(instagramURL!) {
            UIApplication.shared.open(instagramURL!, options: [:], completionHandler: nil)
        } else {
            print("Instagram app not installed.")
        }
        shareInstagramButton.isEnabled = true
        isShareInstagram = false
    }
    
    func saveVideo(isSaveCameraRoll: Bool) {
        guard let pixelView = pixelImageView else {return}
        let endingTime = 2.5
        
        videoService.makeBlankVideo(blankImage: #imageLiteral(resourceName: "whiteBg"), videoSize: container.bounds.size, outputPath: localBlankVideoPath, duration: duration * Double(pixelView.pixelStack.count) + endingTime) { () -> Void in
            self.exportVideo(isSaveCameraRoll)
        }
    }
    func exportVideo(_ isSaveCameraRoll: Bool) {
        let input = VideoExportInput()
        videoID = NSUUID().uuidString
        
        input.videoPath = self.localVideoPath
        input.isSaveCameraRoll = isSaveCameraRoll
        
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
    private func playVideo(with url: URL) {
        let player = AVPlayer(url: url)
        self.playerViewController = AVPlayerViewController()
        self.playerViewController!.player = player
        self.present(self.playerViewController!, animated: true) {
            self.playerViewController!.player!.play()
        }
    }
    
    func videoExportServiceExportSuccess(with url: URL, and isSaveCameraRoll: Bool) {
        print("sucess")
        if isSaveCameraRoll {
            DispatchQueue.main.async {
                if self.isShareInstagram {
                    self.shareInstagram(with: url)
                } else {
                    self.playVideo(with: url)
                    self.saveCameraRollButton.isEnabled = true
                }
            }
        } else {
            shareVideo(with: url)
        }
    }
    
    func videoExportServiceExportFailedWithError(error: NSError) {
        print(error)
    }
    
    func videoExportServiceExportProgress(progress: Float) {
        
    }
}

