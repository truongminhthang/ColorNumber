//
//  DrawViewController.swift
//  ColorNumber
//
//  Created by Chung Sama on 1/3/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let cellPadding: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension DrawViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberColorCell", for: indexPath) as! NumberColorCell
        if indexPath.item == 0 {
            cell.imageView.image = #imageLiteral(resourceName: "ic_plus")
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "ic_food")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            return
        }
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate
//extension DrawViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let collectionHeight = collectionView.frame.size.height
//        let padding = cellPadding
////        let availableWidth = collectionWidth - CGFloat(padding)
//        let cellWidth:Int = Int(collectionHeight) - 2*padding
//        let cellHeight = Int(collectionHeight) - 2*padding
//        return CGSize.init(width: cellWidth, height: cellHeight)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(cellPadding)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return CGFloat(cellPadding)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: CGFloat(cellPadding), left: CGFloat(cellPadding), bottom: CGFloat(cellPadding), right: CGFloat(cellPadding))
//    }
//}

