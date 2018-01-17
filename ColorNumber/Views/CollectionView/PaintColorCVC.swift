//
//  PaintColorCVC.swift
//  ColorNumber
//
//  Created by HoangLuyen on 1/9/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class PaintColorCVC: UICollectionViewCell {
    @IBOutlet weak var labelNumberText: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    override var isSelected: Bool {
        didSet {
            labelNumberText.animateToSmaller { [unowned self] (sucess) in
                self.selectedView.isHidden = !self.isSelected
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelNumberText.text = ""
    }
}
