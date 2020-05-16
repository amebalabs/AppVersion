//
//  AppDelegate.swift
//  AppVersionExample
//

import UIKit
import AppVersion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appVersion = AppVersion.shared
        appVersion.updateFrequency = 1 // I want to check for updates once a day
        appVersion.alertsEnabled = true // I want UI alerts, presenting update options
        appVersion.alertType = .skippable // I want UI alert to include "Skip" button
        appVersion.neverEnabled = true // I want UI alert to include "Never" butoon
        appVersion.alertPresentationStyle = .actionSheet // I want UI presented as an actionSheet
        appVersion.checkBeforeUpdatePresented = { // I want to present UI only if App Store version has more than 1 review and average rating is higher than 3
            return (appVersion.appStoreVersionInfo?.ratingsCount ?? 0) > 1
                && (appVersion.appStoreVersionInfo?.averageRating ?? 0) > 3
        }
        // I want to check the update for current region only
        appVersion.regionCode = Locale.current.regionCode!
        
        appVersion.run()
        
        return true
    }

}
