//
//  DataService.swift
//  CollectionViewInTableCell
//
//  Created by nguyencuong on 1/3/18.
//  Copyright © 2018 nguyencuong. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataService{
    static let share = DataService()
    
    //MARK: return image from indexPathCollectionCell
    var selectedIndexPath : IndexPath?
    var selectedImage: PixelImageView? {
        if let indexPath = selectedIndexPath {
            return categories[indexPath.section][indexPath.row]
        }
        return nil
    }

    
    //MARK: data
    private var _categories: [Category]!
    
    var categories: [Category]{
        set{
            _categories = newValue
        }
        get{
            if _categories == nil {
                loadFilePlist()
            }
            return _categories
        }
    }
    
    //MARK: load data from file plist.
    func loadFilePlist() {
        categories = []
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "Library", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }

        guard let root = myDict as? JSON,
            let imageLibrary = root["ImageLibrary"] as? [JSON]
            else { return }
        
        for value in imageLibrary {
            if let data = Category(dict: value){
                _categories.append(data)
            }
        }
    }
    
   
}
