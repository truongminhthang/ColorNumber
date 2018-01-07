//
//  CustomCollectionViewLayout.swift
//  ColorNumber
//
//  Created by Chung-Sama on 2018/01/07.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {
    private var numberOfColumns: Int!
    private var numberOfRows: Int!
    
    // It is two dimension array of itemAttributes
    private var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    
    // It is one dimension of itemAttributes
    private var cache = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        if self.cache.isEmpty {
            self.numberOfColumns = self.collectionView?.numberOfItems(inSection: 0)
            self.numberOfRows = self.collectionView?.numberOfSections
            
            // Dynamically change cellWidth if total cell width is smaller than whole bounds
            /* if (self.collectionView?.bounds.size.width)!/CGFloat(self.numberOfColumns) > cellWidth {
             self.cellWidth = (self.collectionView?.bounds.size.width)!/CGFloat(self.numberOfColumns)
             }
             */
            
            for row in 0..<self.numberOfRows {
                var row_temp = [UICollectionViewLayoutAttributes]()
                for column in 0..<self.numberOfColumns {
                    let indexPath = IndexPath(item: column, section: row)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = CGRect(x: Constants.shared.CELL_WIDTH*CGFloat(column), y: Constants.shared.CELL_HEIGHT*CGFloat(row), width: Constants.shared.CELL_WIDTH, height: Constants.shared.CELL_HEIGHT)
                    row_temp.append(attributes)
                    self.cache.append(attributes)
                }
                self.itemAttributes.append(row_temp)
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: CGFloat(self.numberOfColumns)*Constants.shared.CELL_WIDTH, height: CGFloat(self.numberOfRows)*Constants.shared.CELL_HEIGHT)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
