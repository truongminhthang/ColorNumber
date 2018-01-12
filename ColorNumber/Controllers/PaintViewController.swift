//
//  PaintColorVC.swift
//  ColorNumber
//
//  Created by HoangLuyen on 1/9/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class PaintViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let color: [String: String] = ["1": "C11ADB", "2": "6049FE", "3": "24DDC9", "4": "35EA64", "5": "FF7C60", "6":"F74747", "7": "EA1717", "8": "B50101", "9": "390122", "10": "097564", "11": "0DA890", "12": "B4780E", "13": "27D9BD", "14": "30B653", "15": "DA654C", "16": "B23232"]
    var image: UIImage?
    var symbols = [String]()
    let cellPadding: Int = 10
    var colors = DataService.share.dataPaintColor
    fileprivate let maxImageSize = CGSize(width: 50, height: 50)
    fileprivate lazy var palette: AsciiPalette = AsciiPalette()
    fileprivate var currentView: Canvas?
    
    var pixels = Array<Array<UILabel>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if image != nil {
            displayImage(image!)
        } else {
            displayImageNamed("kermit")
        }
        configureZoomSupport()
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
        displayImage(image)
    }
    
    fileprivate func displayImage(_ image: UIImage) {
//        collectionView.isHidden = true
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            
            let // Rotate first because the orientation is lost when resizing.
            rotatedImage = image.imageWithFixedOrientation(),
            resizedImage = rotatedImage.imageConstrainedToMaxSize(self.maxImageSize),
            asciiArtist  = AsciiArtist(resizedImage, self.palette),
            symbolsMatix = asciiArtist.createAsciiArt()
            self.symbols = self.palette.symbols.filter { $0 != " " }
            DispatchQueue.main.async {
                self.displayAsciiArt(symbolsMatix)
//                print(self.symbols)
                self.collectionView.reloadData()
//                self.collectionView.isHidden = false
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
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UIScrollViewDelegate

extension PaintViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView != scrollView as? UICollectionView {
            setCenterScrollView(scrollView, currentView)
        }
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
}

// MARK: - CollectionView delegate, CollectionView DataSource
extension PaintViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbols.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.PAINT_SECTION, for: indexPath) as! PaintSection
            cell.imageView.image = UIImage(named: "\(colors[indexPath.row].hex)")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.PAINT_CELL, for: indexPath) as! PaintColorCVC
            cell.labelNumberText.text = String(symbols[indexPath.row - 1])
            cell.labelNumberText.textColor = UIColor.red
            cell.backGroundView.backgroundColor = UIColor.color(fromHexString: color["\(indexPath.row)"]!)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            self.currentView!.paintBrushColor = UIColor.white
        }
        else {
            self.currentView!.paintBrushColor = UIColor.color(fromHexString: color["\(indexPath.row)"]!)
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
