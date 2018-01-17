//
//  PaintViewController.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/17/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class PaintViewController: UIViewController {

    fileprivate let maxImageSize = CGSize(width: 50, height: 50)
    
    let cellPadding: Int = 10
    
    var pixelImageView: PixelImageView?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.maximumZoomScale = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        renderingImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateZoomSettings(animated: true)

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
    
    @objc
    func colorFillDone(_ notification: Notification) {
        guard let intensityNumber = notification.object as? Int else {return}
        if let cell = collectionView.cellForItem(at: IndexPath(item: intensityNumber + 1, section: 0)) as? ColorItem {
            cell.isDone = true
        } else {
            collectionView.reloadData()
        }
    }
    
    @objc
    func colorFillNotDone(_ notification: Notification) {
        guard let intensityNumber = notification.object as? Int else {return}
        if let cell = collectionView.cellForItem(at: IndexPath(item: intensityNumber + 1, section: 0)) as? ColorItem {
            cell.isDone = false
        } else {
            collectionView.reloadData()
        }
        
    }
    @objc
    func gameCompleted(_ notification: Notification) {
       showAlert(vc: self, title: "Mission Complete!", message: "Congratuation!")
    }

    
    // MARK: - Rendering
    
    fileprivate func renderingImage() {
        guard let image = DataService.share.selectedImage else { return }
        let rotatedImage = image.imageWithFixedOrientation() // Rotate first because the orientation is lost when resizing.
        let resizedImage = rotatedImage.imageConstrainedToMaxSize(self.maxImageSize)
        pixelImageView = PixelImageView(image: resizedImage)
        scrollView.contentSize = pixelImageView!.bounds.size
        scrollView.addSubview(pixelImageView!)
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func fillAll(_ sender: Any) {
        AppDelegate.shared.patternColors.forEach{$0.pixels.forEach{$0.fillColorNumber = $0.intensityNumber}}
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
        return AppDelegate.shared.patternColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorSection", for: indexPath) as! PaintSection
            cell.imageView.image = #imageLiteral(resourceName: "ic_delete")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorItem
            cell.labelNumberText.text = "\(indexPath.row - 1)"
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
            pixelImageView?.selectedColorNumber = indexPath.row - 1
        }
    }
    
    
}
// MARK: - Layout CollectionView Cell
extension PaintViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.size.width
        let numberCellRow = 7
        let padding = (numberCellRow - 1) * cellPadding + 2 * cellPadding
        let availabelWidth = collectionWidth - CGFloat(padding)
        let cellWith: Int = Int(availabelWidth) / numberCellRow
        let cellHeight = cellWith
        return CGSize.init(width: cellWith, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(cellPadding)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(cellPadding)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(CGFloat(cellPadding), CGFloat(cellPadding), CGFloat(cellPadding), CGFloat(cellPadding))
    }
}
