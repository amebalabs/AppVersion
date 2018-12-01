//
//  AppInfoTests.swift
//  AppVersionTests
//

import XCTest
@testable import AppVersion

class AppInfoTest: XCTestCase {
    let testResults: [AppInfo.VersionFormat: String]  = [
        .short: "1.1",
        .shortWithName: "AppVersion 1.1",
        .long: "1.1 (42)",
        .longWithName: "AppVersion 1.1 (42)"
    ]
}

extension AppInfoTest {
    func testShortVersion() {
        XCTAssert(AppInfo.shortVersion == testResults[.short])
    }
    
    func testShortVersionWithName() {
        XCTAssert(AppInfo.shortVersionWithName == testResults[.shortWithName])
    }
    
    func testLongVersion() {
        XCTAssert(AppInfo.longVersion == testResults[.long])
    }
    
    func testLongVersionWithName() {
        XCTAssert(AppInfo.longVersionWithName == testResults[.longWithName])
    }
    
    func testAllVersions() {
        for (format, value) in testResults {
            XCTAssert(AppInfo.version(with: format) == value)
        }
    }
    
    func testName() {
        XCTAssert(AppInfo.appName == "AppVersion")
    }
    
    func testBuild() {
        XCTAssert(AppInfo.appBuild == "42")
    }
    
}
