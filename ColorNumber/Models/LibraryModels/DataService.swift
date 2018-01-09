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
    
    //MARK: Index Seleced Cell.
    var selectedHead: Int?

    //MARK: data
    private var _dataLibrary: [DataLibrary]!
    
    var dataLibrary: [DataLibrary]{
        set{
            _dataLibrary = newValue
        }
        get{
            if _dataLibrary == nil {
                loadFilePlist()
            }
            return _dataLibrary
        }
    }
    
    //MARK: load data from file plist.
    func loadFilePlist() {
        dataLibrary = []
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "Library", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }

        guard let root = myDict as? JSON,
            let imageLibrary = root["ImageLibrary"] as? [JSON]
            else { return }
        
        for value in imageLibrary {
            if let data = DataLibrary(dict: value){
                _dataLibrary.append(data)
            }
        }
    }
    // MARK: - data Paint color
    var _dataPaintColor: [PaintColorPlist]?
    var dataPaintColor: [PaintColorPlist] {
        get {
            if _dataPaintColor == nil {
                loadPaintColor()
            }
            return _dataPaintColor ?? []
        }
        set {
            _dataPaintColor = newValue
        }
    }
    // MARK: - load data from PainColor.Plist
    func loadPaintColor() {
        guard let dictionary = PlistService().getDictionaryFrom(plist: "PaintColor.plist") else { return  }
        guard let paintDictionaries = dictionary["PaintColor"] as? [JSON] else { return  }
        _dataPaintColor = []
        for paintDictionary in paintDictionaries {
            if let paintColor = PaintColorPlist(dictionary: paintDictionary) {
                _dataPaintColor?.append(paintColor)
            }
        }
    }
    
}
