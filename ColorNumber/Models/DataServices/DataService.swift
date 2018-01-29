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
            return pixelImageViews[indexPath.section][indexPath.row]
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
    
    var pixelImageViews: [[PixelImageView]] = Array(repeating: [], count: 4)
    
    private var _editedImageView: [PixelImageView]?
    
    var editedImageView: [PixelImageView] {
        set {
            _editedImageView = newValue
        }
        get {
            if _editedImageView == nil {
                updateEditedImageView()
            }
            return _editedImageView ?? []
        }
    }
    
    func updateSelectedImage(pixelImage: PixelImageView) {
        for rowIndex in (0..<pixelImageViews.count) {
            for colIndex in (0..<pixelImageViews[rowIndex].count) {
                if pixelImage == pixelImageViews[rowIndex][colIndex] {
                    selectedIndexPath = IndexPath(row: colIndex, section: rowIndex)
                    return
                }
            }
        }
    }
    
    func updateEditedImageView() {
        _editedImageView = pixelImageViews.flatMap{$0}.filter{$0.pixelStack.count != 0}
        NotificationCenter.default.post(name: .updateEditedImages, object: nil)
    }
    
    private var _fetchedResultsController: NSFetchedResultsController<PixelImageEntity>? = nil

    var fetchedResultsController: NSFetchedResultsController<PixelImageEntity> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<PixelImageEntity> = PixelImageEntity.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        
        let sortDescriptor = NSSortDescriptor(key: "categoryID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: "categoryID", cacheName: "Master")
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
            if let objects = _fetchedResultsController?.fetchedObjects {
                if objects.count == 0 {
                    DataService.share.loadSample()
                    try _fetchedResultsController!.performFetch()
                } else {
                    pixelImageViews = []
                    for sectionIndex in 0..<(_fetchedResultsController!.sections?.count ?? 0) {
                        pixelImageViews.append([])
                        for rowIndex in 0..<(_fetchedResultsController!.sections![sectionIndex].numberOfObjects) {
                            let entity = _fetchedResultsController!.object(at: IndexPath(row: rowIndex, section: sectionIndex))
                            pixelImageViews[sectionIndex].append(PixelImageView(imageEntity: entity))
                        }
                    }
                    NotificationCenter.default.post(name: .loadSampleComplete, object: nil)

                }
            }
            
            
            
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    
    func loadSample() {
        pixelImageViews = Array(repeating: [], count: 4)
        let imageDictionaries = PlistServices().getDictionaryFrom(plist: "ListImage.plist")?["Images"] as! [JSON]
        for dict in imageDictionaries {
            let imageString = dict["name"] as! String
            let image = UIImage(named: imageString)
            let category = dict["categoryID"] as! String
            let pixelImageView = PixelImageView(image: image!, categoryID: category)
            pixelImageView.createEntity()
            pixelImageViews[Int(category) ?? 0].append(pixelImageView)
        }
        AppDelegate.saveContext()
        NotificationCenter.default.post(name: .loadSampleComplete, object: nil)
    }
    

    
   
}
