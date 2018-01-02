//
//  ImportViewController.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit
import MobileCoreServices

class ImportViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellPadding: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if let image = UIImage(named: "ghost_tiny") {
        //            setupWithImage(image)
        //        }
        
        if let image = UIImage(named: "ghost_tiny") {
            if let reader = ImagePixelReader(image: image) {
                
                //get alpha or color
                let alpha = reader.componentAt(.alpha, x: 10, y:10)
                let color = reader.colorAt(x:10, y: 10).uiColor
                
                self.view.backgroundColor = color
                self.view.alpha = CGFloat(alpha)
                
                //getting all the pixels you need
                
                var values = ""
                
                //iterate over all pixels
                for x in 0 ..< Int(image.size.width){
                    for y in 0 ..< Int(image.size.height){
                        
                        let color = reader.colorAt(x: x, y: y)
                        values += "[\(x):\(y):\(color)] "
                        
                    }
                    //add new line for every new row
                    values += "\n"
                }
                
                print(values)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupWithImage(_ image: UIImage) {
        let fixedImage = image.imageWithFixedOrientation()
        fixedImage.logPixelsOfImage()
    }
    
}
// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension ImportViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImportCell", for: indexPath) as! CustomImportCell
        if indexPath.item == 0 {
            cell.imageView.image = #imageLiteral(resourceName: "ic_plus")
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "ic_food")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            pressNewPost()
            return
        } else {
            let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "DrawViewController") as! DrawViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension ImportViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionWidth = collectionView.frame.size.width
        let numberCellPerRow = 3
        let padding = (numberCellPerRow - 1) * cellPadding + 2 * cellPadding // left, right, and space between cells
        let availableWidth = collectionWidth - CGFloat(padding)
        let cellWidth:Int =  Int(availableWidth) / numberCellPerRow
        let cellHeight = cellWidth
        return CGSize.init(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(cellPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(cellPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CGFloat(cellPadding), left: CGFloat(cellPadding), bottom: CGFloat(cellPadding), right: CGFloat(cellPadding))
    }
}

extension ImportViewController {
    func pressNewPost() {
        let alertVC = UIAlertController.init(title: nil, message:nil, preferredStyle: .alert)
        let fromCameraAction = UIAlertAction.init(title: "Camera", style: .default) { (alertAction) in
            let picker = UIImagePickerController.init()
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
                self.present(picker, animated: true, completion: nil)
            } else {
                print("Camera is unavailable!")
            }
        }
        
        let fromCameraRollAction = UIAlertAction.init(title: "Camera Roll", style: .default) { (alertAction) in
            let picker = UIImagePickerController.init()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            self.present(picker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(fromCameraAction)
        alertVC.addAction(fromCameraRollAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}
extension ImportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
