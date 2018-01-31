//
//  LibraryViewController.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit
import os.log
import CoreData

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var reviewLb: DesignableLabel!
    @IBOutlet weak var feedbackLb: DesignableLabel!
    @IBOutlet weak var tableView: UITableView!
    var pixelImageViews = DataService.share.pixelImageViews
    let numbersOfItemInRow :CGFloat = 2
    let itemPadding: CGFloat = 10
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if UserDefaults.standard.object(forKey: "Key") == nil {
            UserDefaults.standard.set(false, forKey: "Key")
        }
        setupView()
        registerNotification()
        _ = DataService.share.fetchedResultsController
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: .loadSampleComplete, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func handleNotification(_ notification: Notification) {
         pixelImageViews = DataService.share.pixelImageViews
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: .showTabBar, object: 0)
        //MARK: Reload row have selected
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup view
    func setupView() {
        let tapReview = UITapGestureRecognizer.init(target: self, action: #selector(self.review(_:)))
        reviewLb.addGestureRecognizer(tapReview)
        let tapFeedback = UITapGestureRecognizer.init(target: self, action: #selector(self.feedback(_:)))
        feedbackLb.addGestureRecognizer(tapFeedback)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
            case "showDetailLibrary":
                let vc = segue.destination as? DetailLibraryViewController
                vc?.indexFromLibrary = tableView.indexPathForSelectedRow?.row
            case "showPaintVC":
                break
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

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    // CollectionViewDataSource.
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pixelImageViews[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCollectionViewCell", for: indexPath) as! LibraryCollectionViewCell
        cell.imageIcon.image = pixelImageViews[collectionView.tag][indexPath.row].displayImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DataService.share.selectedIndexPath = IndexPath(row: indexPath.row, section: collectionView.tag)
        if let image = DataService.share.selectedImage {
            AppDelegate.shared.patternColors = image.patternColors
            image.reloadData()
            AppDelegate.shared.patternColors = AppDelegate.shared.patternColors.filter { $0.pixels.count != 0}

        }
        self.performSegue(withIdentifier: "showPaintVC", sender: nil)
    }
    
    
}
