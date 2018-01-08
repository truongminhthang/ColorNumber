//
//  DetailsViewController.swift
//  ColorNumber
//
//  Created by Thuy Truong Quang on 12/31/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit


class DetailsViewController: UIViewController{
    // MARK: - Properties
    /// Variables
    var contentView: PixelGridView!
    let image = #imageLiteral(resourceName: "cat3").imageConstrainedToMaxSize(CGSize(width: 50, height: 50))
    
    /// Outlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            self.collectionView.dataSource = self
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            self.scrollView.delegate = self
        }
    }
    /// Life cyrcle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        findColors(image) { (result) in
           // print(result)
        }
    }
    
    /// MARK: - Private Function
    fileprivate func setupUI() {
        contentView = PixelGridView()
        self.contentView.setup(with: image)
        self.scrollView.addSubview(contentView)
        self.scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 0.1
        scrollView.setZoomScale(0.095, animated: true)
        
    }
}

// MARK: - Collection View DataSource
extension DetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (ColorThief.getPalette(from: image, colorCount: 20)?.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let color = ColorThief.getPalette(from: image, colorCount: 20)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = color![indexPath.row].makeUIColor()
        return cell
    }
}


/// Implement ScrollViewDelegate
extension DetailsViewController: UIScrollViewDelegate {
    
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
