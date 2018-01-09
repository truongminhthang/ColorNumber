//
//  PaintColorVC.swift
//  ColorNumber
//
//  Created by HoangLuyen on 1/9/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class PaintViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let cellPadding: Int = 10
    var dataService = DataService.share.dataPaintColor
    fileprivate let labelFont = UIFont(name: "Menlo", size: 7)!
    fileprivate let maxImageSize = CGSize(width: 100, height: 100)
    fileprivate lazy var palette: AsciiPalette = AsciiPalette(font: self.labelFont)
    fileprivate var currentView: Canvas?
    
    var pixels = Array<Array<UILabel>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayImageNamed("kermit")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Rendering
    
    fileprivate func displayImageNamed(_ imageName: String) {
        let image = UIImage(named: imageName)!
        configureZoomSupport()
        displayImage(image)
    }
    
    fileprivate func displayImage(_ image: UIImage) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            
            let // Rotate first because the orientation is lost when resizing.
            rotatedImage = image.imageWithFixedOrientation(),
            resizedImage = rotatedImage.imageConstrainedToMaxSize(self.maxImageSize),
            asciiArtist  = AsciiArtist(resizedImage, self.palette),
            symbolsMatix = asciiArtist.createAsciiArt()
            
            DispatchQueue.main.async {
                self.displayAsciiArt(symbolsMatix)
            }
        }
    }
    
    fileprivate func displayAsciiArt(_ matrix: [[String]]) {
        self.currentView?.removeFromSuperview()
        self.currentView = Canvas(itemSize: 10, symbolsMatix: matrix)
        self.scrollView.addSubview(currentView!)
        self.scrollView.contentSize = self.currentView!.frame.size
        self.updateZoomSettings(animated: true)
    }
    // MARK: - Zooming support
    
    fileprivate func configureZoomSupport() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = 5
    }
    
    fileprivate func updateZoomSettings(animated: Bool) {
        let
        scrollSize  = scrollView.frame.size,
        contentSize = scrollView.contentSize,
        scaleWidth  = scrollSize.width / contentSize.width,
        scaleHeight = scrollSize.height / contentSize.height,
        scale       = min(scaleWidth, scaleHeight)
        scrollView.minimumZoomScale = scale/2
        scrollView.setZoomScale(scale, animated: animated)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        setCenterScrollView(scrollView, currentView)
        return currentView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let subView = scrollView.subviews[0]
        setCenterScrollView(scrollView, subView)
    }
    
    func setCenterScrollView(_ scrollView: UIScrollView,_ subView: UIView?) {
        if subView != nil {
            let offsetX = max(Double(scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5,0.0)
            let offsetY = max(Double(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5,0.0)
            // adjust the center of view
            subView!.center = CGPoint(x: scrollView.contentSize.width * 0.5 + CGFloat(offsetX),y: scrollView.contentSize.height * 0.5 + CGFloat(offsetY))
        }
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
// MARK: - CollectionView delegate, CollectionView DataSource
extension PaintViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataService.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.PAINT_SECTION, for: indexPath) as! PaintSection
            cell.imageView.image = UIImage(named: "\(dataService[indexPath.row].hex)")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.PAINT_CELL, for: indexPath) as! PaintColorCVC
            cell.labelNumberText.text = String(dataService[indexPath.row].number)
            cell.backGroundView.backgroundColor = UIColor.color(fromHexString: "\(dataService[indexPath.row].hex)")
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            view.backgroundColor = UIColor.white
        }
        else {
            view.backgroundColor = UIColor.color(fromHexString: "\(dataService[indexPath.row].hex)")
        }
    }
    
}
// MARK: - Layout CollectionView Cell
extension PaintViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.size.width
        let numberCellRow = 9
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
