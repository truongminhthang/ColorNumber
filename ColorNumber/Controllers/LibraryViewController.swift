//
//  LibraryViewController.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit
import os.log
import StoreKit

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var addThree: UIImageView!
    @IBOutlet weak var watchVideo: UIImageView!
    @IBOutlet weak var reviewLb: DesignableLabel!
    @IBOutlet weak var feedbackLb: DesignableLabel!
    @IBOutlet weak var tableView: UITableView!
    
    let itemPadding: CGFloat = 10
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if UserDefaults.standard.object(forKey: "Key") == nil {
            UserDefaults.standard.set(false, forKey: "Key")
        }
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MARK: Reload row have selected
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.reloadRows(at: [selectedRow], with: .none)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup view
    func setupView() {
        let tapWatchVideoImage = UITapGestureRecognizer.init(target: self, action: #selector(self.watchVideo(_:)))
        watchVideo.addGestureRecognizer(tapWatchVideoImage)
        let tapAddThree = UITapGestureRecognizer.init(target: self, action: #selector(self.addThree(_:)))
        addThree.addGestureRecognizer(tapAddThree)
        let tapReview = UITapGestureRecognizer.init(target: self, action: #selector(self.review(_:)))
        reviewLb.addGestureRecognizer(tapReview)
        let tapFeedback = UITapGestureRecognizer.init(target: self, action: #selector(self.feedback(_:)))
        feedbackLb.addGestureRecognizer(tapFeedback)
    }
    
    // MARK: Action Navigation view
    @objc func watchVideo(_ recogznier: UITapGestureRecognizer) {
        let rootVC = WatchVideoViewController.instance
        watchVideo.animate { (complete) in
            if complete {
                self.present(rootVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func addThree(_ recogznier: UITapGestureRecognizer) {
        
    }
    
    @objc func review(_ recogznier: UITapGestureRecognizer) {
        self.reviewLb.animate { (complete) in
            self.getUserDefault()
        }
    }
    
    @objc func feedback(_ recogznier: UITapGestureRecognizer) {
        self.feedbackLb.animate { (complete) in
            print("Feedback")
        }
    }
    
    // MARK: - ReViewApp
    private func getUserDefault() {
        if UserDefaults.standard.bool(forKey: "Key") == false {
            showReviewAlert()
        }
    }
    
    private func showReviewAlert() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/id{ID App}?action=write-review") {
            showAlertController(url: url)
        }
        
    }
    
    private func showAlertController(url: URL) {
        let alert = UIAlertController(title: "Review request",
                                      message: "We are always grateful for your help!\nPlease review！",
                                      preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: {
                                            (action:UIAlertAction!) -> Void in
                                            UserDefaults.standard.set(false, forKey: "Key")
        })
        alert.addAction(cancelAction)
        
        let reviewAction = UIAlertAction(title: "Review",
                                         style: .default,
                                         handler: {
                                            (action:UIAlertAction!) -> Void in
                                            UserDefaults.standard.set(true, forKey: "Key")
                                            if #available(iOS 10.0, *) {
                                                UIApplication.shared.open(url, options: [:])
                                            }
                                            else {
                                                UIApplication.shared.openURL(url)
                                            }
        })
        alert.addAction(reviewAction)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
            case "showDetailLibrary":
                let vc = segue.destination as? DetailLibraryViewController
                vc?.indexFromLibrary = tableView.indexPathForSelectedRow?.row
            case "showPaitnVC":
                debugPrint("not action")
            
        default:
            fatalError("not segue")
        }
    }
    
}

//MARK: - TableViewController

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.share.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryTableViewCell", for: indexPath) as! LibraryTableViewCell
        cell.titleHead.text = DataService.share.categories[indexPath.row].titleHeader
        cell.titleHead.textColor = DataService.share.categories[indexPath.row].colorTitle
        cell.imageHeader.image = DataService.share.categories[indexPath.row].iconHeader
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let libraryTableViewCell = cell as? LibraryTableViewCell else { return }
        libraryTableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightCell = view.frame.height / 2
        return heightCell
    }
    
}


//MARK: - CollectionViewController

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    // ConllectionViewDelegateFlowLayout.
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 3
        
        let paddingSpace = itemPadding * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemPadding
    }
    
    // CollectionViewDataSource.
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataService.share.categories[collectionView.tag].listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCollectionViewCell", for: indexPath) as! LibraryCollectionViewCell
        cell.imageIcon.image = DataService.share.categories[collectionView.tag][indexPath.row]?.image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DataService.share.selectedIndexPath = IndexPath(row: indexPath.row, section: collectionView.tag)
        if let image = DataService.share.selectedImage {
            AppDelegate.shared.patternColors = image.patternColors
            if image.pixelsNumber.count == 0 {
                image.createPixelMatrix()
            }
        }

        self.performSegue(withIdentifier: "showPaitnVC", sender: nil)
    }
    
    
}
