//
//  ColorItem.swift
//  ColorNumber
//
//  Created by HoangLuyen on 1/9/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class ColorItem: UICollectionViewCell {
    @IBOutlet weak var labelNumberText: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var doneImage: UIImageView!

    
    override var isSelected: Bool {
        didSet {
            labelNumberText.animateToSmaller { [unowned self] (sucess) in
                self.selectedView.isHidden = !self.isSelected
            }
        }
    }
    
    var isDone: Bool = false {
        didSet {
            doneImage.isHidden = !isDone
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isDone = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelNumberText.text = ""
    }
}
