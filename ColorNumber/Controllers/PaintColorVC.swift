//
//  PaintColorVC.swift
//  ColorNumber
//
//  Created by HoangLuyen on 1/6/18.
//  Copyright © 2018 BigZero. All rights reserved.
//

import UIKit

class PaintColorVC: UIViewController {
    @IBOutlet weak var viewColor: UIView!
    
    let cellPadding: Int = 5
    var dataService = DataService.shared.dataPaintColor
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK: - CollectionView delegate, CollectionView DataSource
extension PaintColorVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataService.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paintcolor", for: indexPath) as! PaintColorCVC
        if indexPath.item == 0 {
            cell.eraserView.image = UIImage(named: "\(dataService[indexPath.row].hex)")
            cell.labelNumber.isHidden = true
            cell.viewBackGround.backgroundColor = UIColor.clear
            cell.viewBackGround.cornerRadius = 0
            cell.viewBackGround.borderColor = UIColor.clear
            cell.eraserView.borderWidth = 0
        }
        else {
            cell.eraserView.isHidden = true
            cell.labelNumber.text = String(dataService[indexPath.row].number)
            cell.viewBackGround.backgroundColor = UIColor.color(fromHexString: "\(dataService[indexPath.row].hex)")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            viewColor.backgroundColor = UIColor.white
        } else {
            viewColor.backgroundColor = UIColor.color(fromHexString: "\(dataService[indexPath.row].hex)")
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
