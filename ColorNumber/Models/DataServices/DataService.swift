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
    
    var imagePixels: [ImagePixelEntity] = []
    
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
        _categories = []
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
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: - Coredata
    
    func insertEntity(imagePixelsInfo: [PixelInfo]) {
        if selectedIndexPath != nil {
            let imagePixelEntity = ImagePixelEntity(context: AppDelegate.context)
            imagePixelEntity.id = "\(selectedIndexPath!.row)"
            imagePixelEntity.category = _categories[selectedIndexPath!.section].nameCategory
            imagePixelEntity.pixelsInfo = imagePixelsInfo
            imagePixelEntity.isEdited = true
            imagePixelEntity.isComplete = false
            AppDelegate.saveContext()
        }
    }
    
    func createEntity(imagePixelsInfo: [PixelInfo], imagePixelFillter: [PixelInfo], isComplete: Bool, isEdited: Bool) {
        if selectedIndexPath != nil {
            let imagePixelEntity = ImagePixelEntity(context: AppDelegate.context)
            imagePixelEntity.id = "\(selectedIndexPath!.row)"
            imagePixelEntity.category = _categories[selectedIndexPath!.section].nameCategory
            imagePixelEntity.pixelsInfo = imagePixelsInfo
            imagePixelEntity.imagePixelFillter = imagePixelFillter
            imagePixelEntity.isEdited = isEdited
            imagePixelEntity.isComplete = isComplete
            AppDelegate.saveContext()
        }
    }
    
    func upadte(imagePixelsInfo: [PixelInfo], imagePixelFillter: [PixelInfo], isComplete: Bool, category: String,and id: String) {
        if let imagePixelEntity = getEntityWithCategoryAndID(category: category, and: id) {
            imagePixelEntity.imagePixelFillter = imagePixelFillter
            imagePixelEntity.pixelsInfo = imagePixelsInfo
            imagePixelEntity.isComplete = isComplete
            AppDelegate.saveContext()
        } else {
            createEntity(imagePixelsInfo: imagePixelsInfo, imagePixelFillter: imagePixelFillter, isComplete: isComplete, isEdited: true)
        }
    }
    
    func getEntityWithCategoryAndID(category: String,and id: String) -> ImagePixelEntity? {
        let predicateCategory = NSPredicate(format: "category == %@", category)
        let predicateID = NSPredicate(format: "id == %@", id)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImagePixelEntity")
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateCategory, predicateID])
        do {
            let result = try AppDelegate.context.fetch(fetchRequest) as! [ImagePixelEntity]
            if let entity = result.first {
                return entity
            } else {
                print("No have entity with category \(category) and id \(id)")
            }
        } catch {
            print("Can't get")
        }
        return nil
    }
    
    func getdata() {
        do {
            guard let imagePixelEntitys = try AppDelegate.context.fetch(ImagePixelEntity.fetchRequest()) as? [ImagePixelEntity] else { return }
            imagePixelEntitys.forEach({ (imagePixelEntity) in
                print("///////////////////////////////////////////////")
                print("\(imagePixelEntity.id ?? "") \(imagePixelEntity.category ?? "")")
                if let pixelsInfo = imagePixelEntity.pixelsInfo {
                    pixelsInfo.forEach({ pixelInfo in
                         print("Pixel infomation: Origin(x: \(pixelInfo.originPoint.x), y: \(pixelInfo.originPoint.y)), Color(red: \(pixelInfo.red), green: \(pixelInfo.green), blu: \(pixelInfo.blu))")
                    })
                }
            })
        } catch {
            print("error")
        }
    }
}
