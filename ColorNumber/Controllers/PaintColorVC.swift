//
//  PaintColorVC.swift
//  ColorNumber
//
//  Created by HoangLuyen on 1/9/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class PaintColorVC: UIViewController {
    @IBOutlet weak var changeBackgroundView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellPadding: Int = 10
    var dataService = DataService.share.dataPaintColor
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
// MARK: - CollectionView delegate, CollectionView DataSource
extension PaintColorVC: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataService.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paintcolor", for: indexPath) as! PaintColorCVC
        if indexPath.item == 0 {
            cell.labelNumberText.isHidden = true
            cell.backGroundView.backgroundColor = UIColor.clear
            cell.backGroundView.cornerRadius = 0
            cell.backGroundView.borderWidth = 0
            cell.eraserView.image = UIImage(named: "\(dataService[indexPath.row].hex)")
        } else {
            cell.eraserView.isHidden = true
            cell.labelNumberText.text = String(dataService[indexPath.row].number)
            cell.backGroundView.backgroundColor = UIColor.color(fromHexString: "\(dataService[indexPath.row].hex)")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            changeBackgroundView.backgroundColor = UIColor.clear
        }
        else {
            changeBackgroundView.backgroundColor = UIColor.color(fromHexString: "\(dataService[indexPath.row].hex)")
        }
    }
    
}
// MARK: - Layout CollectionView Cell
extension PaintColorVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.size.width
        let numberCellRow = 9
        let padding = (numberCellRow - 1) * cellPadding + 2 * cellPadding
        let availabelWidth = collectionWidth - CGFloat(padding)
        let cellWith: Int = Int(availabelWidth) / numberCellRow
        let cellHeight = cellWith
        return CGSize.init(width: cellWith, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(cellPadding)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(cellPadding)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(CGFloat(cellPadding), CGFloat(cellPadding), CGFloat(cellPadding), CGFloat(cellPadding))
    }
}
