//
//  ProcessCount.swift
//  ReviewTemplate
//
//  Created by Mehedi Hasan on 14/2/22.
//

import Foundation
import UIKit
import StoreKit

import UIKit


var AppStoreID = ""
var isReviewInProgress = false

func processCompleteCount()->Int{
    
    if !UserDefaults.standard.bool(forKey: ReviewDefaultsKeys.isNoNeedToUpdatePrecessCompleteCount){
        // If the count has not yet been stored, this will return 0
        var count = UserDefaults.standard.integer(forKey: ReviewDefaultsKeys.processCompletedCountKey)
        count += 1
        UserDefaults.standard.set(count, forKey: ReviewDefaultsKeys.processCompletedCountKey)
        
        print("Process completed \(count) time(s)")
        return count
    }else{
        return UserDefaults.standard.integer(forKey: ReviewDefaultsKeys.processCompletedCountKey)
    }
}

func requestReview() {
    
    let count = processCompleteCount()
    
    // Get the current bundle version for the app
    //let infoDictionaryKey = kCFBundleVersionKey as String
    //guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
        //else { fatalError("Expected to find a bundle version in the info dictionary") }
    guard let currentVersion = Bundle.main.releaseVersionNumber
    else { fatalError("Expected to find a bundle version in the info dictionary") }
    
    let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: ReviewDefaultsKeys.lastVersionPromptedForReviewKey)
    
    // Has the process been completed several times and the user has not already been prompted for this version?
    if currentVersion != lastVersionPromptedForReview && !isReviewInProgress {
        
        if count >= ReviewDefaultsKeys.completedTaskNumber{
            
            UserDefaults.standard.set(true, forKey: ReviewDefaultsKeys.isNoNeedToUpdatePrecessCompleteCount)
            isReviewInProgress = true
            let twoSecondsFromNow = DispatchTime.now() + 2.0
            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                
                if let scene = UIApplication.shared.connectedScenes
                        .first(where: { $0.activationState == .foregroundActive })
                        as? UIWindowScene {
                    print("Call for show Review")
                    if #available(iOS 14.0, *) {
                        SKStoreReviewController.requestReview(in: scene)
                    } else {
                        // Fallback on earlier versions
                        SKStoreReviewController.requestReview()
                    }
                    isReviewInProgress = false
                    UserDefaults.standard.set(currentVersion, forKey: ReviewDefaultsKeys.lastVersionPromptedForReviewKey)
                }
               
            }
        }else{
            debugPrint("Request not accepted")
        }
        
    }else{
        debugPrint("Request not accepted")
    }
}

func requestReviewManually() {
    // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
    //       You can find the App Store ID in your app's product URL
   // URL(string: "https://apps.apple.com/app/idXXXXXXXXXX?action=write-review")
    guard let writeReviewURL = URL(string: "https://apps.apple.com/app/\(AppStoreID)?action=write-review")
        else { fatalError("Expected a valid URL") }
    UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
}

func resetChecks() {
    // Just for testing, reset the run counter and last bundle version checked
    UserDefaults.standard.set(0, forKey: ReviewDefaultsKeys.processCompletedCountKey)
    UserDefaults.standard.set("", forKey: ReviewDefaultsKeys.lastVersionPromptedForReviewKey)
    UserDefaults.standard.set(false, forKey: ReviewDefaultsKeys.isNoNeedToUpdatePrecessCompleteCount)
    print("All checks have been reset")
}
