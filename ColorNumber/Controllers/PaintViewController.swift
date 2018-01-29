//
//  PaintViewController.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/17/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class PaintViewController: UIViewController {
    
    var pixelImageView: PixelImageView? = DataService.share.selectedImage
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.maximumZoomScale = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemHeight = view.frame.height/14 - 5
        layout.itemSize = CGSize(width: itemHeight, height: itemHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        Pixel.size = CGSize(width: 10, height: 10)
        renderingImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateZoomSettings(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pixelImageView?.capture()
        //        saveImagePixel()
        updatePixelFillter()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(colorFillDone), name: .fillColorDone, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(colorFillNotDone), name: .fillColorNotDone, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gameCompleted), name: .gameCompleted, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updatePixelFillter() {
        if pixelImageView != nil {
            var imagePixelFillter: [PixelInfo] = []
            pixelImageView!.pixelStack.forEach { pixel in
                let pixelFillter = PixelInfo(intensity: pixel.intensityNumber, originPoint: pixel.coordinate.originPoint, originVideo: pixel.coordinate.originVideo, red: Double(pixel.color.red), green: Double(pixel.color.green), blu: Double(pixel.color.blue))
                imagePixelFillter.append(pixelFillter)
            }
            var imagePixelsInfo: [PixelInfo] = []
            pixelImageView!.pixelsNumber.forEach({ row in
                row.forEach({ aPixel in
                    let pixelInfo = PixelInfo(intensity: aPixel.intensityNumber, originPoint: aPixel.coordinate.originPoint, originVideo: aPixel.coordinate.originVideo, red: Double(aPixel.color.red), green: Double(aPixel.color.green), blu: Double(aPixel.color.blue))
                    imagePixelsInfo.append(pixelInfo)
                })
            })
            DataService.share.upadte(imagePixelsInfo: imagePixelsInfo, imagePixelFillter: imagePixelFillter, isComplete: false, category: DataService.share.categories[DataService.share.selectedIndexPath!.section].nameCategory, and: "\(DataService.share.selectedIndexPath!.row)")
        }
    }
    
    @objc
    func colorFillDone(_ notification: Notification) {
        guard let intensityNumber = notification.object as? Int else {return}
        var colorIndex = 0
        for (index, item) in AppDelegate.shared.patternColors.enumerated() {
            if item.colorOrder == intensityNumber {
                colorIndex = index
                break
            }
        }
        if let cell = collectionView.cellForItem(at: IndexPath(item: colorIndex + 1, section: 0)) as? ColorItem {
            cell.isDone = true
        } else {
            collectionView.reloadData()
        }
    }
    
    @objc
    func colorFillNotDone(_ notification: Notification) {
        guard let intensityNumber = notification.object as? Int else {return}
        var colorIndex = 0
        for (index, item) in AppDelegate.shared.patternColors.enumerated() {
            if item.colorOrder == intensityNumber {
                colorIndex = index
                break
            }
        }
        if let cell = collectionView.cellForItem(at: IndexPath(item: colorIndex + 1, section: 0)) as? ColorItem {
            cell.isDone = false
        } else {
            collectionView.reloadData()
        }
        
    }
    @objc
    func gameCompleted(_ notification: Notification) {
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    // MARK: - Rendering
    
    fileprivate func renderingImage() {
        guard let image = pixelImageView else { return }
        scrollView.contentSize = image.bounds.size
        scrollView.addSubview(image)
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate

extension PaintViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView != scrollView as? UICollectionView {
            setCenterScrollView(scrollView, pixelImageView)
        }
        return pixelImageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        pixelImageView!.actualScalingParamter = scrollView.zoomScale
        setCenterScrollView(scrollView, pixelImageView)
    }
    fileprivate func updateZoomSettings(animated: Bool) {
        let scrollSize  = scrollView.frame.size
        let contentSize = scrollView.contentSize
        let scaleWidth  = scrollSize.width / contentSize.width
        let scaleHeight = scrollSize.height / contentSize.height
        let scale       = min(scaleWidth, scaleHeight)
        pixelImageView!.zoomScaleForRemovingColor = scale
        scrollView.minimumZoomScale = scale
        scrollView.setZoomScale(scale, animated: animated)
    }
    func setCenterScrollView(_ scrollView: UIScrollView,_ subView: UIView?) {
        if subView != nil {
            let offsetX = max(Double(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5,0.0)
            let offsetY = max(Double(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5,0.0)
            // adjust the center of view
            subView!.center = CGPoint(x: scrollView.contentSize.width * 0.5 + CGFloat(offsetX),y: scrollView.contentSize.height * 0.5 + CGFloat(offsetY))
        }
    }
}
// MARK: - CollectionView delegate, CollectionView DataSource
extension PaintViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppDelegate.shared.patternColors.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorSection", for: indexPath) as! PaintSection
            cell.imageView.image = #imageLiteral(resourceName: "ic_delete")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorItem
            cell.labelNumberText.text = String(AppDelegate.shared.patternColors[indexPath.row - 1].colorOrder)
            cell.labelNumberText.textColor = UIColor.red
            cell.labelNumberText.backgroundColor = AppDelegate.shared.patternColors[indexPath.row - 1].color.uiColor
            cell.isDone = AppDelegate.shared.patternColors[indexPath.row - 1].count == 0
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            pixelImageView?.selectedColorNumber = nil
        }
        else {
            pixelImageView?.selectedColorNumber = AppDelegate.shared.patternColors[indexPath.row - 1].colorOrder
        }
    }
}
