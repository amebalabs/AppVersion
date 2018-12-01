//
//  UserDefaults+AppVersion.swift
//  AppVersion
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let lastCheckDate = "co.ameba.AppVersion.lastCheckDate"
        static let skipVersion = "co.ameba.AppVersion.skipVersion"
        static let versionHistory = "co.ameba.AppVersion.versionHistory"
        static let never = "co.ameba.AppVersion.never"
    }

    static var appVersionLastCheckDate: Date? {
        get {
            return standard.object(forKey: Keys.lastCheckDate) as? Date
        }
        set {
            standard.set(newValue, forKey: Keys.lastCheckDate)
            standard.synchronize()
        }
    }

    static var appVersionSkipVersion: Version? {
        get {
            guard let version = standard.object(forKey: Keys.skipVersion) as? String else { return nil }
            return Version(stringLiteral: version)
        }
        set {
            standard.set(newValue?.string, forKey: Keys.skipVersion)
            standard.synchronize()
        }
    }

    static var appVersionHistory: [Version: Int]? {
        get {
            guard let data = standard.object(forKey: Keys.versionHistory) as? Data else { return nil }
            return try? PropertyListDecoder().decode([Version: Int].self, from: data)
        }
        set {
            standard.set(try? PropertyListEncoder().encode(newValue), forKey: Keys.versionHistory)
            standard.synchronize()
        }
    }

    static var appVersionNever: Bool {
        get {
            return standard.bool(forKey: Keys.never)
        }
        set {
            standard.set(newValue, forKey: Keys.never)
            standard.synchronize()
        }
    }

    static func resetAppVersionKeys() {
        standard.removeObject(forKey: Keys.lastCheckDate)
        standard.removeObject(forKey: Keys.skipVersion)
        standard.removeObject(forKey: Keys.versionHistory)
        standard.removeObject(forKey: Keys.never)
    }
}
