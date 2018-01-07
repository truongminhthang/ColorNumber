//
//  CollectionView.swift
//  ColorNumber
//
//  Created by Chung-Sama on 2018/01/07.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    private var row: Int
    private var column: Int
    init(row: Int, column: Int) {
        let layout = CustomCollectionViewLayout()
        self.row = row
        self.column = column
        super.init(frame: CGRect.zero, collectionViewLayout: layout)
        self.backgroundColor = UIColor.white
        self.register(UINib(nibName: "ImageProcessCell", bundle: nil), forCellWithReuseIdentifier: Constants.shared.IMAGE_PROCESS_CELL_IDENTIFIER)
        self.register(UINib(nibName: "ImageProcessHeadCell", bundle: nil), forCellWithReuseIdentifier: Constants.shared.IMAGE_PROCESS_HEAD_CELL_IDENTIFIER)
        self.isDirectionalLockEnabled = true
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCollectionView() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    // MARK: CollectionView datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return column
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return column
    }
    
    override func numberOfItems(inSection section: Int) -> Int {
        return row
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let column = indexPath.row
        let row = indexPath.section
        
//        if column == 0 {
//            let cell: ImageProcessHeadCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.IMAGE_PROCESS_HEAD_CELL_IDENTIFIER, for: indexPath) as! ImageProcessHeadCell
//
//            cell.label.text = "\(row)"
//
//            return cell
//        } else if row == 0 {
//            let cell : ImageProcessHeadCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.IMAGE_PROCESS_HEAD_CELL_IDENTIFIER, for: indexPath) as! ImageProcessHeadCell
//
//            cell.label.text = "\(column)"
//
//            return cell
//        } else {
            let cell : ImageProcessCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.IMAGE_PROCESS_CELL_IDENTIFIER, for: indexPath) as! ImageProcessCell
            
            cell.label.text = "\(column):\(row)"
            
            return cell
//        }
    }
    
    // MARK: CollectionView delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let column = indexPath.row
        let row = indexPath.section
        
        print("\(column)  \(row)")
    }
}

