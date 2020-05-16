//
//  AppVersion.swift
//  AppVersion
//

import UIKit

/// AppVersion provides a set of properties and methods to configure app update tracking behaviour.
/// Can be used as singleton through shared property, or through a set of static variables and methods
open class AppVersion {

    /// Update-suggestion UI Alert Type, used to set the desired update workflow
    public enum AlertType {
        /// Update can be skipped or postponed, presented buttons: Update, Skip, Cancel + Never(must be explicitly enabled with `neverEnabled` property)
        case skippable
        /// Update can't be skipped but can be postponed, presented buttons: Update, Cancel + Never(must be explicitly enabled with `neverEnabled` property)
        case unskippable
        /// Update can't be skipped or postponed, presented buttons: Update. App UI will be completely **BLOCKED**, use carefully
        case blocking
    }

    /// AppVersion Singleton
    public static let shared = AppVersion()

    /// Delegate chaining AppVersionDelegate methods
    public weak var delegate: AppVersionDelegate?

    /// Defines the frequency of App Store update requests in **days**, default: 0 - means with each app launch
    public var updateFrequency: UInt = 0
    /// Checks you want to make before presenting update-suggesting UI. If returns **true** - UI will be presented, if **false** UI will be supressed
    public var checkBeforeUpdatePresented: (() -> Bool) = {return true}

    internal var currentVersion: SemanticVersion = {
        return SemanticVersion(stringLiteral: AppInfo.version)
    }()

    internal var currentAppStoreInfo: AppStoreVersion? {
        didSet {
            guard let version = currentAppStoreInfo?.currentVersion else { return }
            currentAppStoreVersion = version
        }
    }
    /// Inforfmation about the latest version available in App Store
    public var appStoreVersionInfo: AppStoreVersion? {
        return currentAppStoreInfo
    }

    internal var currentAppStoreVersion: SemanticVersion? {
        didSet {
            guard let currentAppStoreVersion = currentAppStoreVersion else { return }
            availableUpdateType = SemanticVersion.updateType(from: currentVersion, to: currentAppStoreVersion)
        }
    }

    internal var availableUpdateType: Version.UpdateType? {
        didSet {
            guard let availableUpdateType = availableUpdateType else { return }
            processUpdate(update: availableUpdateType)
        }
    }

    internal var updateAvailable: Bool {
        return ( availableUpdateType == .major || availableUpdateType == .minor || availableUpdateType == .patch)
    }

    /// Allows user to silence update-suggestion UI forever, i.e. alert will be never shown again. **False** by default
    public var neverEnabled: Bool = false
    /// Enables update-suggestion UI Alerts. **False** by default
    public var alertsEnabled: Bool = false
    /// Disables update-suggestion UI Alerts for **Minor** updates. **False** by default
    public var minorAlertsDisabled: Bool = false
    /// Disables update-suggestion UI Alerts for **Patch** updates. **False** by default
    public var patchAlertsDisabled: Bool = false
    /// UIAlertController alert presentation style. **alert** by default
    public var alertPresentationStyle: UIAlertController.Style = .alert
    /// Update-suggestion UI Alert Type, **unskippable** by default. Rewrites alertTypeMajor,alertTypeMinor and alertTypePatch when set.
    public var alertType: AlertType = .unskippable {
        didSet {
            alertTypeMajor = alertType
            alertTypeMinor = alertType
            alertTypePatch = alertType
        }
    }
    /// Update-suggestion UI Alert Type for **Major** update, **unskippable** by default.
    public var alertTypeMajor: AlertType?
    /// Update-suggestion UI Alert Type for **Minor** update, **unskippable** by default.
    public var alertTypeMinor: AlertType?
    /// Update-suggestion UI Alert Type for **Patch** update, **unskippable** by default.
    public var alertTypePatch: AlertType?
    /// add region Code example "IN" for INDIA, to check the version for specific region or leave it for default
    public var regionCode: String?

    /// Initializes AppVersion, call it from application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions:...) delegate in your AppDelegate
    /// Logs app launch and checks for an update in App Store
    public func run() {
        logLaunch()
        checkAppStoreForUpdate()
    }

    internal func checkAppStoreForUpdate(now: Bool = false) {
        if !now && updateFrequency != 0 {
            if let lastCheckDate = lastCheckDate, lastCheckDate.daysFromToday() < updateFrequency {
                print("To eraly to check!")
                return
            }
        }

        AppStoreAPI.requestVersion(for: regionCode) { version, error in
            if let error = error {
                print(error)
                return
            }
            if let version = version {
                self.currentAppStoreInfo = version
                self.delegate?.appVersionCheckedForNewVersion()
                UserDefaults.appVersionLastCheckDate = Date()
            }
        }
    }

    /// Checks for update, non-blocking. Use it when you need to force the check ignoring `updateFrequency` setting
    public func checkAppStoreForUpdateNow() {
        checkAppStoreForUpdate(now: true)
    }

    private func logLaunch() {
        let launchCount = UserDefaults.appVersionHistory?[currentVersion] ?? 0
        var launchHistory = UserDefaults.appVersionHistory ?? [:]
        launchHistory[currentVersion] = launchCount + 1
        UserDefaults.appVersionHistory = launchHistory

        if launchCount == 0 {
            delegate?.appVersionFirstLaunchForThisVersion()
        }
    }

    internal func processUpdate(update: Version.UpdateType) {
        guard update != .none else { return }
        guard UserDefaults.appVersionSkipVersion != currentAppStoreVersion else {
            delegate?.appVersionSuppressedBySkipFlag()
            return
        }

        delegate?.appVersionNewVersionDetected()

        switch update {
        case .major:
            delegate?.appVersionNewMajorVersionDetected()
            if alertsEnabled {
                showAlert(alertTypeMajor ?? alertType)
            }
        case .minor:
            delegate?.appVersionNewMinorVersionDetected()
            if alertsEnabled, !minorAlertsDisabled {
                showAlert(alertTypeMinor ?? alertType)
            }
        case .patch:
            delegate?.appVersionNewPatchVersionDetected()
            if alertsEnabled, !patchAlertsDisabled {
                showAlert(alertTypePatch ?? alertType)
            }
        case .none:
            print("Do nothing")
        }
    }

    private func launchAppStore() {
        delegate?.appVersionUserPressedUpdate()
        if let appId = currentAppStoreInfo?.appId {
            UIApplication.shared.open(NSURL(string: "itms-apps://itunes.apple.com/app/\(appId)")! as URL, options: [: ], completionHandler: nil)
        }
    }

    internal func skipCurentAppStoreVersion() {
        UserDefaults.appVersionSkipVersion = currentAppStoreVersion //Bad?
        delegate?.appVersionUserPressedSkip()
    }

    internal func enableNeverShowAlert() {
        UserDefaults.appVersionNever = true
        delegate?.appVersionUserPressedNeverPresent()
    }

    /// Resets all persistance information stored by AppVersion: version launch history and user preferences(skip, never)
    public func resetAppVersionState() {
        UserDefaults.resetAppVersionKeys()
    }
}

// MARK: UI Presenter
extension AppVersion {
    internal func showAlert(_ type: AlertType) {
        guard !UserDefaults.appVersionNever else { return }
        guard checkBeforeUpdatePresented() else { return }

        DispatchQueue.main.async {
            let alert = UIAlertController.appVersionAlert(self.alertPresentationStyle, version: self.currentAppStoreVersion?.string ?? "")
            alert.addUpdateAction(handler: self.launchAppStore)

            switch type {
            case .skippable:
                alert.addCancleAction(handler: self.delegate?.appVersionUserPressedCancel)
                alert.addSkipAction(handler: self.skipCurentAppStoreVersion)
            case .unskippable:
                alert.addCancleAction(handler: self.delegate?.appVersionUserPressedCancel)
            case .blocking:
                break
            }

            if self.neverEnabled, type != .blocking {
                alert.addNeverAction(handler: self.enableNeverShowAlert)
            }

            alert.present()
        }
    }
}

// MARK: Launch history and user preferences
extension AppVersion {
    /// Date on which last check for update was performed
    public var lastCheckDate: Date? {
        return UserDefaults.appVersionLastCheckDate
    }
    /// Update version which user decided to skip
    public var skipVersion: Version? {
        return UserDefaults.appVersionSkipVersion
    }
    /// Version history installed & launched on this device, contains launch  counts for each version.
    /// Not preserved between reinstalls
    public var versionHistory: [Version: Int]? {
        return UserDefaults.appVersionHistory
    }
    /// Returns number of launches for this version
    public var launchesForThisVersion: Int {
        return UserDefaults.appVersionHistory?[currentVersion] ?? 1
    }
    /// Indicates if user asked to silence update-suggesting UI alerts
    public var neverShowAlert: Bool {
        return UserDefaults.appVersionNever
    }
}
