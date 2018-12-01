//
//  ViewController.swift
//  AppVersionExample
//

import UIKit
import AppVersion

class TableViewController: UITableViewController {
    let appVersion = AppVersion.shared
    
    @IBOutlet weak var lastCheckDateLabel: UILabel!
    @IBOutlet weak var skipVersionLabel: UILabel!
    @IBOutlet weak var versionHistoryLabel: UILabel!
    @IBOutlet weak var launchesForThisVersionLabel: UILabel!
    @IBOutlet weak var neverShowAlertLabel: UILabel!

    @IBAction func checkForUpdateButtonPressed(_ sender: Any) {
        appVersion.checkAppStoreForUpdateNow()
    }
    
    @IBAction func resetFlagsPressed(_ sender: Any) {
        appVersion.resetAppVersionState()
        setAppVersionFlags()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addVersionFooter(with: .longWithName)
        appVersion.delegate = self
        
        setAppVersionFlags()
    }
    
    func setAppVersionFlags() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let lastCheckDate = self.appVersion.lastCheckDate {
                self.lastCheckDateLabel.text = formatter.string(from: lastCheckDate)
            }
            if let skipVersion = self.appVersion.skipVersion {
                self.skipVersionLabel.text = skipVersion.string
            }
            self.versionHistoryLabel.text = "[\(self.appVersion.versionHistory?.keys.compactMap({$0.string}).joined(separator: ",") ?? "")]"
            self.launchesForThisVersionLabel.text = String(self.appVersion.launchesForThisVersion)

            self.neverShowAlertLabel.text = self.appVersion.neverShowAlert.description
        }
    }
}

extension TableViewController: AppVersionDelegate {
    func appVersionNewVersionDetected(version: AppStoreVersion, update: Version.UpdateType) {
        
    }
    
    func appVersionUserPressedSkip() {
        //update skipVersionLabel
        setAppVersionFlags()
        print("Wow, \(#function)")
    }
    
    func appVersionCheckedForNewVersion() {
        //update lastCheckDateLabel
        setAppVersionFlags()
    }

    func appVersionUserPressedUpdate() {
        print("Wow, \(#function)")
    }

    func appVersionUserPressedCancel() {
        print("Wow, \(#function)")
    }

    func appVersionSuppressedBySkipFlag() {
        print("Wow, \(#function)")
    }

    func appVersionFirstLaunchForThisVersion() {
        print("Wow, \(#function)")
    }
}
