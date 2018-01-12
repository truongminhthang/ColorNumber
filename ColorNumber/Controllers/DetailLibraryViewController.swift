//
//  DetailLibraryViewController.swift
//  ColorNumber
//
//  Created by cuong on 1/6/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class DetailLibraryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleHead: UILabel!
    let numbersOfItemInRow :CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (view.frame.width - 10 /*left*/ - 10 /*right*/ - 10 * (numbersOfItemInRow - 1)) / numbersOfItemInRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let select = DataService.share.selectedHead {
            titleHead.text = DataService.share.dataLibrary[select].titleHeader
            titleHead.textColor = DataService.share.dataLibrary[select].colorTitle
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Action.
    @IBAction func backLibrary(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension DetailLibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let indexSelected = DataService.share.selectedHead else { return 0 }
        return DataService.share.dataLibrary[indexSelected].listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.shared.DETAIL_LIBRARY_COLLECTION_VIEW_CELL, for: indexPath) as! LibraryCollectionViewCell
        
        if let indexSelected = DataService.share.selectedHead {
            cell.imageIcon.image = DataService.share.dataLibrary[indexSelected].listImage[indexPath.row]
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "PaintViewController") as! PaintViewController
//        if let indexSelected = DataService.share.selectedHead {
//            vc.image = DataService.share.dataLibrary[indexSelected].listImage[indexPath.row]
//        }
        DataService.share.selectedIndexPath = indexPath
    }
}
