//
//  GoogleAdsMob.swift
//  Cleaner
//
//  Created by ChungTran on 10/18/17.
//  Copyright © 2017 BaBaBiBo. All rights reserved.
//

import UIKit
import GoogleMobileAds


//MARK: - Create GoogleAdMob Class
class GoogleAdMob: NSObject {
    
    //MARK: - Google Ads Unit ID
    struct GoogleAdsUnitID {
        static var strInterstitialAdsID = "ca-app-pub-1435684048935421/7918441836"
    }
    
    static let sharedInstance : GoogleAdMob = GoogleAdMob()
    private var isInitializeInterstitial = false
    private var interstitialAds: GADInterstitial!

    var isTestMode = false
    
    override init() {
        super.init()
        self.createInterstitial()
    }
    
    private func createInterstitial() {
        guard !isTestMode else {return}
        interstitialAds = GADInterstitial(adUnitID: GoogleAdsUnitID.strInterstitialAdsID)
        interstitialAds.delegate = self
        interstitialAds.load(GADRequest())
    }
    
    func showInterstitial() {
        guard !isTestMode else {return}
        guard AppDelegate.shared.reachability.connection != .none else {return}
        if interstitialAds.isReady {
            interstitialAds.present(fromRootViewController: (UIApplication.shared.keyWindow?.rootViewController)!)
        } else {
            createInterstitial()
        }
    }
   
}

// MARK: - GADInterstitialDelegate

extension GoogleAdMob: GADInterstitialDelegate {
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        showInterstitial()
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        
    }
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        
    }
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        
    }
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        
    }
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        
    }
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(error.description)")
        
    }
}

