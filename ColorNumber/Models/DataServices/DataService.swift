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
    
    var pixelImageView: PixelImageView?
    
    //MARK: return image from indexPathCollectionCell
    var selectedIndexPath : IndexPath?
    var selectedImage: UIImage? {
        if let indexPath = selectedIndexPath {
            return dataLibrary[indexPath.section][indexPath.row]
        }
        return nil
    }
    
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
    
    private var _colorFillter: [ColorFillter]?
    var colorFillter: [ColorFillter] {
        get {
            if _colorFillter == nil {
                _colorFillter = getColorFromDataBase()
            }
            return _colorFillter ?? []
        }
        set {
            _colorFillter = newValue
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
    
    func insertColor(red: CGFloat, green: CGFloat, blu: CGFloat, x: Int, y: Int) {
        
        let colorFillterEntity = ColorFillter(context: AppDelegate.context)
        colorFillterEntity.red = Float(red)
        colorFillterEntity.green = Float(green)
        colorFillterEntity.blu = Float(blu)
        colorFillterEntity.x = Int32(x)
        colorFillterEntity.y = Int32(y)
        AppDelegate.shared.saveContext()
        print(getColorFromDataBase().count)
    }
    
    func removeColorFromDataBase(x: Int, y: Int) {
        var colorsFillter = getColorFromDataBase()
        for i in 0..<colorsFillter.count {
            if colorsFillter[i].x == Int32(x) && colorsFillter[i].y == Int32(y) {
                AppDelegate.context.delete(colorsFillter[i])
            }
        }
        AppDelegate.shared.saveContext()
        print(getColorFromDataBase().count)
    }
    
    func getColorFromDataBase() -> [ColorFillter] {
        return try! AppDelegate.context.fetch(ColorFillter.fetchRequest()) as! [ColorFillter]
    }
}
