//
//  ImportViewController.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit
import AVFoundation
import CoreVideo
import CoreImage

class ImportViewController: UIViewController, UIImagePickerControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate {
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput : AVCapturePhotoOutput?
    var videoInput: AVCaptureInput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var monoLayer: CALayer?
    var monoFilterName: String = "CIPhotoEffectMono"
    var pixelFilterName: String = "CIPixellate"
    var pixelFilter: CIFilter?
    var monoFilter: CIFilter?
    var scale: Int? = 30
    var ciImage: CIImage?
    @IBOutlet weak var switchCameraBt: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var pickImageBT: UIButton!
    @IBOutlet weak var slider: UISlider!
    var isTakePhoto: Bool = false
    private let sessionQueue = DispatchQueue(label: "session queue")
    lazy var context: CIContext = {
        let eaglContext = EAGLContext(api: EAGLRenderingAPI.openGLES2)
        let options = [kCIContextWorkingColorSpace:NSNull()]
        return CIContext(eaglContext: eaglContext!, options: options)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizationCaptureDevice()
    }
    
    func authorizationCaptureDevice() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
            
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
            
        default:
            setupResult = .notAuthorized
        }
    }
    
    func liveCamera() {
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                self.setupDevice()
                self.setupCaptureSession()
                self.setupPreviewLayer()
                self.startingRunningCaptureSession()
                
            case .notAuthorized:
                DispatchQueue.main.async {
                    self.switchCameraBt.isEnabled = false
                    showAlertToOpenSetting(title: "Color Number", message: "Color Number doesn't have permission to use the camera, please change privacy settings")
                }
                
            case .configurationFailed:
                self.switchCameraBt.isEnabled = false
                DispatchQueue.main.async {
                    let alertMsg = "Alert message when something goes wrong during capture session configuration"
                    let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
                    showAlert(vc: self, title: "Color Number", message: message)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .hideTabBar, object: nil)
        liveCamera()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.captureSession.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    private var setupResult: SessionSetupResult = .success
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
        }
        currentCamera = frontCamera
        setupInputOutput()
        
    }
    func setupInputOutput() {
        guard setupResult == .success && currentCamera != nil else {return}
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            if captureSession.canAddInput(captureDeviceInput) {
                captureSession.addInput(captureDeviceInput)
            }
            
            if #available(iOS 11.0, *) {
                photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue)!
        monoLayer = CALayer()

        DispatchQueue.main.async {[unowned self] in
            self.cameraPreviewLayer?.frame = self.cameraView.bounds
            let monoFrame = self.cameraPreviewLayer?.bounds.insetBy(dx: -10, dy: -10)
            self.monoLayer?.frame = monoFrame ?? .zero
            self.cameraView.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
            self.cameraView?.layer.sublayers?.append(self.monoLayer!)
        }
    }
    
    func startingRunningCaptureSession() {
        captureSession.startRunning()
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [((kCVPixelBufferPixelFormatTypeKey as NSString) as String):NSNumber(value:kCVPixelFormatType_32BGRA)]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        
        let queue = DispatchQueue(label: "captureQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    @IBAction func switchCamera(_ sender: UIButton) {
        //Change camera source
        
        
        let session = self.captureSession
        //Indicate that some changes will be made to the session
        //Remove existing input
        guard let currentCameraInput:AVCaptureInput = session.inputs.first else { return }
        session.beginConfiguration()
        self.switchCameraBt.isEnabled = false
        session.removeInput(currentCameraInput)
        
        //Get new input
        var newCamera:AVCaptureDevice! = nil
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            if (input.device.position == .back) {
                newCamera = self.frontCamera
            }
            else {
                newCamera = self.backCamera
            }
        }
        
        //Add input to session
        var err: NSError?
        var newVideoInput: AVCaptureDeviceInput!
        do {
            newVideoInput = try AVCaptureDeviceInput(device: newCamera)
        } catch let err1 as NSError {
            err = err1
            newVideoInput = nil
        }
        
        if(newVideoInput == nil || err != nil) {
            print("Error creating capture device input: \(err!.localizedDescription)")
        }
        else {
            session.addInput(newVideoInput)
        }
        
        //Commit all the configuration changes at once
        session.commitConfiguration()
        
        self.switchCameraBt.isEnabled = true
        
    }
    
    
    @IBAction func pickImageFromLB(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        
    }
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)") }
        let photoVC = PhotoViewController.instance
        let navigationController = UINavigationController(rootViewController: photoVC)
        photoVC.imageTaken = selectedImage
        photoVC.scale = scale
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    //MARK: Take a Photo
    @IBAction func takePhoto(_ sender: UIButton) {
        isTakePhoto = true
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        var outputImage = CIImage(cvImageBuffer: imageBuffer)
        let transform = getOrientation()
        outputImage = outputImage.transformed(by: transform)
        ciImage = outputImage
        addPixelFilter(outputImage: outputImage, scale: scale!)
        outputImage = (self.pixelFilter?.outputImage)!
        addMonoFilter(outputImage: outputImage)
        outputImage = (self.monoFilter?.outputImage)!
        let cgImage = self.context.createCGImage(outputImage, from: outputImage.extent)
        DispatchQueue.main.sync {
            monoLayer?.contents = cgImage
        }
        if isTakePhoto == true {
            takeAPhoto(sampleBuffer: sampleBuffer)
        }
    }
    func takeAPhoto(sampleBuffer: CMSampleBuffer) {
        isTakePhoto = false
            let photoVC =  PhotoViewController.instance
            photoVC.imageTaken = UIImage(ciImage: ciImage!)
            photoVC.scale = scale
            DispatchQueue.main.async {
                self.present(photoVC, animated: true, completion: nil)
            }
        
    }
    func addPixelFilter(outputImage: Any?, scale: Int ) {
        self.pixelFilter = CIFilter(name: pixelFilterName)
        self.pixelFilter?.setValue(outputImage, forKey: kCIInputImageKey)
        self.pixelFilter?.setValue(scale, forKey: "inputScale")
    }
    func addMonoFilter(outputImage: Any? ) {
        self.monoFilter = CIFilter(name: monoFilterName)
        self.monoFilter?.setValue(outputImage, forKey: kCIInputImageKey)
    }
    
    
    func getOrientation() -> CGAffineTransform {
        let angle: CGFloat = -CGFloat.pi/2
        if let latestInput = captureSession.inputs.first as? AVCaptureDeviceInput {
            let camPosition = latestInput.device.position
            return(camPosition == .front) ? CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(scaleX: -1, y: 1)) : CGAffineTransform(rotationAngle: angle)
        }
        return CGAffineTransform(rotationAngle: angle)
    }
    deinit {
        print("!")
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        let reverseValue = (Int(sender.maximumValue) - currentValue) + Int(sender.minimumValue)
        scale = reverseValue
    }
    
    @IBAction func backTapped(sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: .backToHome, object: nil)
        
    }
}

