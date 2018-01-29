//
//  LibraryModel.swift
//  CollectionViewInTableCell
//
//  Created by nguyencuong on 1/3/18.
//  Copyright © 2018 nguyencuong. All rights reserved.
//

import Foundation
import UIKit
typealias JSON = Dictionary<String, Any>

class Category {
    var iconHeader: UIImage? = UIImage(named: "default")
    var nameCategory: String = ""
    var listImage: [PixelImageView] = []
    var colorTitle: UIColor = UIColor.color(fromHexString: "#000000")
    subscript (imageIndex: Int) -> PixelImageView? {
        guard imageIndex < listImage.count else {
            return nil
        }
        return listImage[imageIndex]
    }
    
    init?(dict: JSON) {
        guard let iconHeader = dict["iconCategory"] as? String,
            let titleHeader = dict["nameCategory"] as? String,
            let listImage = dict["listImage"] as? [String],
            let colorHead = dict["colorCategory"] as? String
        else { return nil }
        self.iconHeader = UIImage(named: iconHeader)
        self.nameCategory = titleHeader
        self.colorTitle = UIColor.color(fromHexString: colorHead)
        for image in listImage {
            if let img = UIImage(named: image) {
                self.listImage.append(PixelImageView(image:img))
            }
        }
    }
    
}

//class image

