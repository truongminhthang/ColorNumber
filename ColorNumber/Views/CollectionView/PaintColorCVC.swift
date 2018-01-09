//
//  PaintColorCVC.swift
//  ColorNumber
//
//  Created by HoangLuyen on 1/9/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class PaintColorCVC: UICollectionViewCell {
    @IBOutlet weak var backGroundView: DesignableView!
    @IBOutlet weak var eraserView: UIImageView!
    @IBOutlet weak var labelNumberText: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        eraserView.image = UIImage(named: "")
        labelNumberText.text = ""
    }
}
