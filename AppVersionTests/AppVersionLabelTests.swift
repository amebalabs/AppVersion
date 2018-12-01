//
//  AppVersionLabelTests.swift
//  AppVersionTests
//

import XCTest
@testable import AppVersion

class AppVersionLabelTests: XCTestCase {
    let testResults: [AppInfo.VersionFormat: String]  = [
        .short: "1.1",
        .shortWithName: "AppVersion 1.1",
        .long: "1.1 (42)",
        .longWithName: "AppVersion 1.1 (42)"
    ]

    func testAllVersions() {
        let label = AppVersionLabel()
        for (format, value) in testResults {
            label.format = format
            XCTAssert( label.text == value)
        }
    }
}
