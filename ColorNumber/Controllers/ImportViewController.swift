//
//  ImportViewController.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

import UIKit
import AVFoundation
import CoreImage

class ImportViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var changeLevelOfDifficult: UISlider!
    
    var imageToSave = UIImage()
    var stillImageOutput: AVCapturePhotoOutput!
    var photoEffectMonoLayer = CALayer()
    var session = AVCaptureSession()
    var aVCaptureDeviceInput: AVCaptureDeviceInput?
    var scale = 30
    var isCaptureImage: Bool = false
    var isFrontCamera: Bool = true {
        didSet {
            if aVCaptureDeviceInput != nil {
                session.removeInput(aVCaptureDeviceInput!)
            }
            if isFrontCamera {
                authorizationCaptureDevice(with: .front)
            } else {
                authorizationCaptureDevice(with: .back)
            }
        }
    }
    let imageFlippedForRightToLeftLayoutDirection: Int32 = 5
    lazy var context: CIContext = {
        let eaglContext = EAGLContext(api: EAGLRenderingAPI.openGLES2)
        let options = [kCIContextWorkingColorSpace:NSNull()]
        return CIContext(eaglContext: eaglContext!, options: options)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFrontCamera = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func takePhoto(_ sender: UIButton) {
        isCaptureImage = true
        sender.isUserInteractionEnabled = false
    }
    @IBAction func changeLevelOfDifficult(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        let reverseValue = (Int(sender.maximumValue) - currentValue) + Int(sender.minimumValue)
        scale = reverseValue
    }
    @IBAction func backTapped(sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: .backToHome, object: nil)
        
    }
    @IBAction func electedImageFromLibrary(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func switchCamera(_ sender: UIButton) {
        session.stopRunning()
        isFrontCamera = !isFrontCamera
    }
}
// MARK : - Configure AVCapture
extension ImportViewController {
    func authorizationCaptureDevice(with device: AVCaptureDevice.Position) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureCamera(with: device)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {[unowned self] granted in
                if !granted {
                    self.cameraDeviceNotDetermined()
                } else {
                    DispatchQueue.main.async {[unowned self] in
                        self.configureCamera(with: device)
                    }
                }
            })
        default:
            cameraDeviceConfigurationFailed(isErrorDevice: false)
        }
    }
    func configureCamera(with device: AVCaptureDevice.Position) {
        session.sessionPreset = .photo
        stillImageOutput = AVCapturePhotoOutput()
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "Buffer Queue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil))
        videoDataOutput.videoSettings = [((kCVPixelBufferPixelFormatTypeKey as NSString) as String):NSNumber(value:kCVPixelFormatType_32BGRA)]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        let cameraDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        var cameraDevice: AVCaptureDevice?
        
        for cameraDv in cameraDevices.devices {
            if cameraDv.position == device {
                cameraDevice = cameraDv
                break
            }
        }
        do {
            if cameraDevice == nil {
                cameraDeviceConfigurationFailed(isErrorDevice: true)
            } else {
                let captureDeviceInput = try AVCaptureDeviceInput(device: cameraDevice!)
                aVCaptureDeviceInput = captureDeviceInput
                configureAVCaptureSession(captureDeviceInput: captureDeviceInput, with: videoDataOutput)
            }
        }
        catch {
            print("Error occured \(error)")
            return
        }
    }
    
    func configureAVCaptureSession(captureDeviceInput: AVCaptureDeviceInput,with videoDataOutput: AVCaptureVideoDataOutput) {
        if session.canAddInput(captureDeviceInput) {
            session.addInput(captureDeviceInput)
            if session.canAddOutput(stillImageOutput) {
                session.addOutput(stillImageOutput)
            }
            if session.canAddOutput(videoDataOutput) {
                session.addOutput(videoDataOutput)
            }
            let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: session)
            captureVideoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            imageView.layer.addSublayer(captureVideoLayer)
            captureVideoLayer.frame = imageView.bounds
            session.startRunning()
            captureVideoLayer.addSublayer(photoEffectMonoLayer)
            photoEffectMonoLayer.frame = imageView.bounds.insetBy(dx: -20, dy: -20)
        }
    }
    func cameraDeviceNotDetermined() {
        DispatchQueue.main.async {
            showAlertToOpenSetting(title: "Color Number", message: "Color Number doesn't have permission to use the camera, please change privacy settings")
        }
    }
    func cameraDeviceConfigurationFailed(isErrorDevice: Bool) {
        DispatchQueue.main.async {
            let alertMsg = "Alert message when something goes wrong during capture session configuration"
            let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
            showAlert(title: "Color Number", message: message, completeHandler: {[unowned self] in
                if !isErrorDevice {
                    self.cameraDeviceNotDetermined()
                } else {
                    self.isFrontCamera = !self.isFrontCamera
                }
            })
        }
    }
}
// MARK : - AVCaptureVideoDataOutputSampleBufferDelegate
extension ImportViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let outputCIImage = CIImage(cvImageBuffer: pixelBuffer).oriented(forExifOrientation: imageFlippedForRightToLeftLayoutDirection)
        if let outputMonoCIPixellate = outputCIImage.monoCIPixellate(with: scale) {
            let cgImageMono = context.createCGImage(outputMonoCIPixellate, from: outputMonoCIPixellate.extent)
            DispatchQueue.main.sync {
                photoEffectMonoLayer.contents = cgImageMono
            }
        }
        if isCaptureImage {
            captureImage(photoSampleBuffer: sampleBuffer)
            isCaptureImage = false
        }
    }
    func captureImage(photoSampleBuffer: CMSampleBuffer) {
        let vc = PhotoViewController.instance
        vc.imageTaken = UIImage(sampleBuffer: photoSampleBuffer)
        vc.scale = scale
        DispatchQueue.main.async {
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate

extension ImportViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)") }
        // Dismiss the picker.
        dismiss(animated: true) { [unowned self] in
            let vc = PhotoViewController.instance
            vc.imageTaken = selectedImage
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}
