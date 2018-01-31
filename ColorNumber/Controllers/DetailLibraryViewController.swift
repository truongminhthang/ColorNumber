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
    var numbersOfItemInRow: CGFloat = 2
    var itemPadding: CGFloat = 10
    var indexFromLibrary: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIScreen.main.bounds.width > 450 {
            numbersOfItemInRow = 3
            itemPadding = 20
        }
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (UIScreen.main.bounds.width - itemPadding /*left*/ - itemPadding /*right*/ - itemPadding * (numbersOfItemInRow - 1)) / numbersOfItemInRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = itemPadding
        layout.sectionInset = UIEdgeInsets(top: itemPadding, left: itemPadding, bottom: itemPadding, right: itemPadding)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.post(name: .showTabBar, object: 0)

        if let select = indexFromLibrary {
            title = DataService.share.categories[select].titleHeader
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
        guard let indexSelected = indexFromLibrary else { return 0 }
        return DataService.share.pixelImageViews[indexSelected].count
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailLibraryCollectionViewCell", for: indexPath) as! LibraryCollectionViewCell
 
        if let indexSelected = indexFromLibrary {
            cell.imageIcon.image = DataService.share.pixelImageViews[indexSelected][indexPath.row].displayImage
        }
 
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selected = indexFromLibrary {
            DataService.share.selectedIndexPath = IndexPath(row: indexPath.row, section: selected)
            if let image = DataService.share.selectedImage {
                AppDelegate.shared.patternColors = image.patternColors
                image.reloadData()
                AppDelegate.shared.patternColors = AppDelegate.shared.patternColors.filter { $0.pixels.count != 0}
                
            }
            self.performSegue(withIdentifier: "showPaintVC", sender: nil)
        }
    }
}

