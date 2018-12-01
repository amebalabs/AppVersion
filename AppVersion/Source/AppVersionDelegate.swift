//
//  AppVersionDelegate.swift
//  AppVersion
//

import Foundation

/// Delegate methods which allow expose a set of events to control update checking workflow
public protocol AppVersionDelegate: NSObjectProtocol {
    /// Succesefull check for new version in App Store
    func appVersionCheckedForNewVersion()
    /// Failed check for new version in App Store
    func appVersionVersionCheckFailed()

    /// New version detected in App Store. Fires for all update types: Major, Minor and Patch
    func appVersionNewVersionDetected()
    /// New **MAJOR** version detected in App Store
    func appVersionNewMajorVersionDetected()
    /// New **Minor** version detected in App Store
    func appVersionNewMinorVersionDetected()
    /// New **Patch** version detected in App Store
    func appVersionNewPatchVersionDetected()
    /// Update "new version available" delegates were suppressed by "Skip this Update" flag
    func appVersionSuppressedBySkipFlag()
    /// Current app version launched for the first time
    func appVersionFirstLaunchForThisVersion()

    /// Update-suggesting UI(alert) was presented on screen
    func appVersionDidPresentUI()
    /// User accepted update proposal, i.e. pressed Update button
    func appVersionUserPressedUpdate()
    /// User Skipped proposed update, i.e pressed SKip button
    func appVersionUserPressedSkip()
    /// User dismissed update proposal, i.e. pressed Cancel button
    func appVersionUserPressedCancel()
    /// User requested to silence update proposals forever, i.e.  pressed Never button
    func appVersionUserPressedNeverPresent()
}

/// Default implementation if AppVersionDelegates
public extension AppVersionDelegate {
    func appVersionCheckedForNewVersion() {}
    func appVersionNewVersionDetected() {}
    func appVersionNewMajorVersionDetected() {}
    func appVersionNewMinorVersionDetected() {}
    func appVersionNewPatchVersionDetected() {}
    func appVersionSuppressedBySkipFlag() {}
    func appVersionFirstLaunchForThisVersion() {}
    func appVersionDidPresentUI() {}
    func appVersionUserPressedUpdate() {}
    func appVersionUserPressedSkip() {}
    func appVersionUserPressedCancel() {}
    func appVersionUserPressedNeverPresent() {}
    func appVersionVersionCheckFailed() {}
}
