//
//  DetailImageController.swift
//  ColorNumber
//
//  Created by Chung-Sama on 2018/01/07.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class DetailImageController: UIViewController {
    
    let collectionView = CollectionView(row: 20, column: 20)
    
    override func viewDidLoad() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        self.view.backgroundColor = UIColor.red
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: ["collectionView": collectionView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: ["collectionView": collectionView]))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.updateCollectionView()
    }
    
}

