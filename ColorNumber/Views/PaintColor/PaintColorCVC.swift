//
//  PaintColorCVC.swift
//  ColorNumber
//
//  Created by HoangLuyen on 1/6/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class PaintColorCVC: UICollectionViewCell {
 
    @IBOutlet weak var viewBackGround: DesignableView!
    
    @IBOutlet weak var eraserView: UIImageView!
    @IBOutlet weak var labelNumber: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
