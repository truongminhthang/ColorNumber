//
//  DetailsViewController.swift
//  ColorNumber
//
//  Created by Thuy Truong Quang on 12/31/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollviewContentView: UIView!
    @IBOutlet weak var imageContainer: PixelGridView!
    let image = #imageLiteral(resourceName: "love_pixel-1")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageContainer.setup(with: self.image)
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 5.0
        self.scrollView.zoomScale = 3.0
        self.collectionView.dataSource = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.scrollviewContentView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        print("Da vao day")
        
        
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale == 1.0 {
            
        }
        print("da het zomm")
    }
    
}

extension DetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.pixelData().count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let color = self.image.pixelData()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = color[indexPath.row].color
        return cell
    }
}

