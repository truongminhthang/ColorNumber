//
//  TableViewCell.swift
//  CollectionViewInTableCell
//
//  Created by nguyencuong on 12/29/17.
//  Copyright © 2017 nguyencuong. All rights reserved.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleHead: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageHeader: UIImageView!
    let itemPadding: CGFloat = 10
    var numbersOfItemInRow: CGFloat = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if UIScreen.main.bounds.width > 420 {
            numbersOfItemInRow = 4
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (UIScreen.main.bounds.width - itemPadding /*left*/ - itemPadding /*right*/ - itemPadding * (numbersOfItemInRow - 1)) / numbersOfItemInRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = itemPadding
        layout.sectionInset = UIEdgeInsets(top: itemPadding * 2, left: itemPadding, bottom: itemPadding * 2, right: itemPadding)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        titleHead.text = ""
    }
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }

}


