//
//  DetailsViewController.swift
//  ColorNumber
//
//  Created by Thuy Truong Quang on 12/31/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit


class DetailsViewController: UIViewController, UIScrollViewDelegate{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    var contentView: PixelGridView!
    let image = #imageLiteral(resourceName: "cat3").imageConstrainedToMaxSize(CGSize(width: 50, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView = PixelGridView()
        self.contentView.setup(with: image)
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.delegate = self
        self.scrollView.addSubview(contentView)
        self.collectionView.dataSource = self
        scrollView.minimumZoomScale = 0.1
        scrollView.setZoomScale(0.095, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        scrollView.contentSize = contentView.frame.size
        if contentView.frame.size.width >= UIScreen.main.bounds.width || contentView.frame.size.height >= UIScreen.main.bounds.height {
            
            contentView.center.x = scrollView.contentSize.width / 2
            contentView.center.y = scrollView.contentSize.height / 2
        } else {
            contentView.center = scrollView.center
        }
       
    }
}

extension DetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Set(image.pixelData()).count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let color = self.image.pixelData()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = color[indexPath.row].color
        return cell
    }
}

