//
//  PixelImageView+CoreData.swift
//  ColorNumber
//
//  Created by Thang Hoa on 1/29/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit
import CoreData

// MARK: - <#Mark#>

extension PixelImageView {
    func createEntity() {
        let pixelImageEntity = PixelImageEntity(context: AppDelegate.context)
        pixelImageEntity.image = image
        pixelImageEntity.pixelStack = pixelStack
        pixelImageEntity.id = id
        pixelImageEntity.categoryID = categoryID
    }
    
    func saveEntity() {
        let predicateID = NSPredicate(format: "id == %@", id ?? "")
        let fetchRequest = NSFetchRequest<PixelImageEntity>(entityName: "PixelImageEntity")
        fetchRequest.predicate = predicateID
        let result = try? AppDelegate.context.fetch(fetchRequest)
        guard let entity = result?.first else {return }
        entity.pixelStack = pixelStack
        entity.currentImage = captureImage
        AppDelegate.saveContext()
    }
    
    convenience init(imageEntity: PixelImageEntity) {
        self.init(image: imageEntity.image as! UIImage, categoryID: "")
        self.id = imageEntity.id
        self.categoryID = imageEntity.categoryID
        self.pixelStack = imageEntity.pixelStack ?? []
        self.captureImage = imageEntity.currentImage as? UIImage
    }
    
    func reloadData() {
        isLoading = true
        createPixelMatrixIfNeed()
        for pixelAnatomic in pixelStack {
            pixelModels[pixelAnatomic.row][pixelAnatomic.col].fillColorNumber = pixelAnatomic.fillColorNumber
        }
        isLoading = false
    }
    
}
