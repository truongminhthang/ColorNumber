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
        if let select = indexFromLibrary {
            titleHead.text = DataService.share.categories[select].titleHeader
            titleHead.textColor = DataService.share.categories[select].colorTitle
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
/*
extension DetailLibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let indexSelected = indexFromLibrary else { return 0 }
        return DataService.share.categories[indexSelected].listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailLibraryCollectionViewCell", for: indexPath) as! LibraryCollectionViewCell
        
        if let indexSelected = indexFromLibrary {
            cell.imageIcon.image = DataService.share.categories[indexSelected].listImage[indexPath.row].displayImage
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selected = indexFromLibrary {
            DataService.share.selectedIndexPath = [selected, indexPath.row]
            self.performSegue(withIdentifier: "showPaitnVC", sender: nil)
        }
    }
}
*/
