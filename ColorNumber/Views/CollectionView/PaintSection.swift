//
//  PaintSection.swift
//  ColorNumber
//
//  Created by Chung-Sama on 2018/01/10.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class PaintSection: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    override var isSelected: Bool {
        didSet {
            imageView.animateToSmaller { (sucess) in}
        }
    }
}
