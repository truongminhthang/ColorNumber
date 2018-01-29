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
    var titleHeader: String = ""
    var colorTitle: UIColor = UIColor.color(fromHexString: "#000000")    
    init?(dict: JSON) {
        guard let iconHeader = dict["iconHeader"] as? String,
            let titleHeader = dict["titleHeader"] as? String,
            let colorHead = dict["colorTitle"] as? String
        else { return nil }
        self.iconHeader = UIImage(named: iconHeader)
        self.titleHeader = titleHeader
        self.colorTitle = UIColor.color(fromHexString: colorHead)
    }
    
}

//class image

