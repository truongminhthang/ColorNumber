//
//  LibraryViewController.swift
//  ColorNumber
//
//  Created by ChungTran on 12/27/17.
//  Copyright © 2017 BigZero. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {

    @IBOutlet weak var addThree: UIImageView!
    @IBOutlet weak var watchVideo: UIImageView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
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
    }
    
    // MARK: Action view
    @objc func watchVideo(_ recogznier: UITapGestureRecognizer) {
        let rootVC = UIStoryboard.main.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        watchVideo.animate { (complete) in
            if complete {
                self.present(rootVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func addThree(_ recogznier: UITapGestureRecognizer) {
        
    }
}
