//
//  MyGallaryViewController.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit

class MyGallaryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var numbersOfItemInRow: CGFloat = 2
    var itemPadding: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if UIScreen.main.bounds.width > 450 {
            numbersOfItemInRow = 3
            itemPadding = 20
        }
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = (UIScreen.main.bounds.width - itemPadding /*left*/ - itemPadding /*right*/ - itemPadding * (numbersOfItemInRow - 1)) / numbersOfItemInRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets(top: itemPadding, left: itemPadding, bottom: itemPadding, right: itemPadding)
        layout.minimumLineSpacing = itemPadding
        registerNotification()
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .updateEditedImages, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func handleNotification(_ notification: Notification) {
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .showTabBar, object: 2)
        DataService.share.updateEditedImageView()
        
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
extension MyGallaryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataService.share.editedImageView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCollectionViewCell", for: indexPath) as! LibraryCollectionViewCell
        cell.imageIcon.image = DataService.share.editedImageView[indexPath.row].image
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let image = DataService.share.editedImageView[indexPath.row]
        DataService.share.updateSelectedImage(pixelImage: image)
            AppDelegate.shared.patternColors = image.patternColors
            image.reloadData()
            AppDelegate.shared.patternColors = AppDelegate.shared.patternColors.filter { $0.pixels.count != 0}
        self.performSegue(withIdentifier: "showPaint", sender: nil)
    }

}
