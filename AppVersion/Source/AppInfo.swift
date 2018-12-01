//
//  AppInfo.swift
//  AppVersion
//

import Foundation

/// Provides information about installed app based on Bundle data
public struct AppInfo {

    /// Version info in this available string formats.
    public enum VersionFormat: String {
        /// Short format `<Version>`: **1.1**
        case short

        /// Short format name `<Name> <Version>`: **App Name 1.1**
        case shortWithName

        /// Long format `<Version> <(Build)>`: **1.1 (42)**
        case long

        /// Short format name `<Name> <Version> <(Build)>`: **App Name 1.1 (42)**
        case longWithName
    }

    internal static let name = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? "AppVersion"
    internal static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.1"
    internal static let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "42"
    internal static let identifier = Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String ?? "co.ameba.AppVersion"

    /// App Name
    public static var appName: String {
        return name
    }

    /// App Build number
    public static var appBuild: String {
        return build
    }

    /// App Bundle identifier
    public static var bundleId: String {
        return identifier
    }

    /// Short version format `<Version>`: **1.1**
    public static var shortVersion: String {
        return version
    }

    /// Short version format with name `<Name> <Version>`: **App Name 1.1**
    public static var shortVersionWithName: String {
        return "\(name) \(shortVersion)"
    }

    /// Long version format with name `<Version> (<Build>)`: **1.1 (42)**
    public static var longVersion: String {
        return "\(version) (\(build))"
    }

    /// Long version format with name `<Name> <Version> (<Build>)`: **App Name 1.1 (42)**
    public static var longVersionWithName: String {
        return "\(name) \(longVersion)"
    }

    /**
     Creates a version string, based on provided format
     
     - Parameters:
     - format: Version format
     
     - Returns: Formatted version string
     */
    public static func version(with format: VersionFormat) -> String {
        switch format {
        case .short:
            return shortVersion
        case .shortWithName:
            return shortVersionWithName
        case .long:
            return longVersion
        case .longWithName:
            return longVersionWithName
        }
    }
}
