//
//  AppVersionTests.swift
//  AppVersionTests
//

import XCTest
@testable import AppVersion

extension AppVersion {
    func testSetCurrentVersion(_ version: Version) {
        currentVersion = version
    }

    func testSetAppStoreVersion(_ version: Version, date: Date = Date()) {
        currentAppStoreVersion = version
        UserDefaults.appVersionLastCheckDate = date
    }
}

class AppVersionTests: XCTestCase {
    let appVersion = AppVersion.shared
    let appStoreInfo = AppStoreVersion(appId: 0,
                                          icon: URL(string: "https://ameba.co")!,
                                          size: "", averageRating: 0, ratingsCount: 0,
                                          releaseDate: Date(), iOSVersion: "11", releaseNotes: "", version: "1.2")
}

extension AppVersionTests {
    func testVersionUpdate() {
        let testCases: [(smaller: String, bigger: String)] = [
            // major
            ("1","2"),
            ("1","2.0"),
            ("1","2.0.0"),
            ("1.0","2"),
            ("1.0","2.0"),
            ("1.0","2.0.0"),
            ("1.0.0","2"),
            ("1.0.0","2.0"),
            ("1.0.0","2.0.0"),

            // minor
            ("0","0.2"),
            ("0","0.2.0"),
            ("0.1","0.2"),
            ("0.1","0.2.0"),
            ("0.1.0","0.2"),
            ("0.1.0","0.2.0"),

            // patch
            ("0","0.0.1"),
            ("0.0","0.0.1"),
            ("0.0.0","0.0.1")
        ]

        testCases.forEach({
            // AppStore Version is bigger -> Update Available
            appVersion.testSetCurrentVersion(Version(stringLiteral: $0.smaller))
            appVersion.testSetAppStoreVersion(Version(stringLiteral: $0.bigger))
            XCTAssertTrue(appVersion.updateAvailable)

            // AppStore Version is smaller -> Update not Available
            appVersion.testSetCurrentVersion(Version(stringLiteral: $0.bigger))
            appVersion.testSetAppStoreVersion(Version(stringLiteral: $0.smaller))
            XCTAssertFalse(appVersion.updateAvailable)
        })
    }

    func testVersionFromString() {
        XCTAssert(Version(stringLiteral: "1").string == "1.0.0")
        XCTAssert(Version(stringLiteral: "1.1").string == "1.1.0")
        XCTAssert(Version(stringLiteral: "0.1").string == "0.1.0")
        XCTAssert(Version(stringLiteral: "1.1.1").string == "1.1.1")
    }

    func testVersionComparison() {
        let testCases: [(smaller: String, bigger: String)] = [
            ("1","2"),
            ("1.0","1.1"),
            ("1.0.0","1.0.1"),
        ]

        testCases.forEach({
            XCTAssertTrue(Version(stringLiteral: $0.bigger) > Version(stringLiteral: $0.smaller))
        })

        XCTAssertFalse(Version(stringLiteral: "1") < Version(stringLiteral: "1"))
    }

    func testCurrentAppStoreInfo() {
        appVersion.currentAppStoreInfo = appStoreInfo
        XCTAssert(appVersion.currentAppStoreVersion == appStoreInfo.currentVersion)
    }

    func testiOSCompatability() {
        XCTAssert(appStoreInfo.isCompatibleWithOS)
        let appStoreInfoFuture = AppStoreVersion(appId: 0,
                                           icon: URL(string: "https://ameba.co")!,
                                           size: "", averageRating: 0, ratingsCount: 0,
                                           releaseDate: Date(), iOSVersion: "14",
                                           releaseNotes: "", version: "1.2")
        XCTAssertFalse(appStoreInfoFuture.isCompatibleWithOS)
    }
}

extension AppVersionTests {
    func testSkipCurentAppStoreVersion() {
        appVersion.resetAppVersionState()
        appVersion.testSetAppStoreVersion("1.1.1")
        appVersion.skipCurentAppStoreVersion()
        XCTAssert(appVersion.skipVersion == "1.1.1")
    }

    func testEnableNeverShowAlert() {
        appVersion.resetAppVersionState()
        appVersion.enableNeverShowAlert()
        XCTAssert(appVersion.neverShowAlert)
    }

    func testVersionHistory() {
        appVersion.resetAppVersionState()
        XCTAssert(appVersion.launchesForThisVersion == 1)
        appVersion.testSetCurrentVersion("1")
        appVersion.run()
        XCTAssert(appVersion.versionHistory == ["1":1])
        appVersion.testSetCurrentVersion("2")
        appVersion.run()
        XCTAssert(appVersion.versionHistory == ["1":1,"2":1])
        appVersion.run()
        XCTAssert(appVersion.launchesForThisVersion == 2)
    }

    func testAppVersionCheckDate() {
        let date = Date()
        appVersion.testSetAppStoreVersion("1", date: date)
        XCTAssert(appVersion.lastCheckDate == date)

    }
}

