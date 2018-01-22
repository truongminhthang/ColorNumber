//
//  DataService.swift
//  CollectionViewInTableCell
//
//  Created by nguyencuong on 1/3/18.
//  Copyright © 2018 nguyencuong. All rights reserved.
//

import Foundation
import UIKit

class DataService{
    static let share = DataService()
    
    //MARK: return image from indexPathCollectionCell
    var selectedIndexPath : IndexPath?
    var selectedImage: UIImage? {
        get {
            if let indexPath = selectedIndexPath {
                return category[indexPath.section][indexPath.row]
            }
            return nil
        }
        set {
            if let indexPath = selectedIndexPath {
                 category[indexPath.section][indexPath.row] = newValue
            }
        }
    }
    
    //MARK: data
    private var _category: [Category]!
    
    var category: [Category]{
        set{
            _category = newValue
        }
        get{
            if _category == nil {
                loadFilePlist()
            }
            return _category
        }
    }
    
    //MARK: load data from file plist.
    func loadFilePlist() {
        category = []
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "Library", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }

        guard let root = myDict as? JSON,
            let imageLibrary = root["ImageLibrary"] as? [JSON]
            else { return }
        
        for value in imageLibrary {
            if let data = Category(dict: value){
                _category.append(data)
            }
        }
    }
}
