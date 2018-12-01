//
//  Version.swift
//  AppVersion
//

import Foundation

/// Semantic versioning 2.0.0 https://semver.org
public typealias SemanticVersion = Version

/// Struct to represent basic Semantic versioning 2.0.0 https://semver.org
public struct Version: Hashable, Codable {
    /// Update type, based on comparison of two semantic versions, i.e. "1.1.1" < "2.0.0"
    public enum UpdateType {
        /// MAJOR update, i.e. first number(X.y.z) is larger
        case major
        /// MINOR update, i.e. second number(x.Y.z) is larger
        case minor
        /// PATCH update, i.e. third number(x.y.Z) is larger
        case patch
        /// Not an update, i.e. versions are equal
        case none
    }

    /// MAJOR(X.y.z) - incompatible API changes
    let major: Int
    /// MINOR(x.Y.z) - add functionality in a backwards-compatible manner
    let minor: Int
    /// PATCH(x.y.Z) - backwards-compatible bug fixes
    let patch: Int

    static func updateType(from: Version, to: Version) -> UpdateType {
        if from.major < to.major {
            return .major
        }
        if from.minor < to.minor {
            return .minor
        }
        if from.patch < to.patch {
            return .patch
        }

        return .none
    }
    /// String representation of version in "X.Y.Z" format
    public var string: String {
        return "\(major).\(minor).\(patch)"
    }
}

extension Version: Comparable {
    /// Implementation of Comparable protocol, allows to compare objects of Version type
    public static func < (lhs: Version, rhs: Version) -> Bool {
        guard lhs.major == rhs.major else {
            return lhs.major < rhs.major
        }

        guard lhs.minor == rhs.minor else {
            return lhs.minor < rhs.minor
        }

        guard lhs.patch == rhs.patch else {
            return lhs.patch < rhs.patch
        }
        return false
    }
}

extension Version: ExpressibleByStringLiteral {
    /**
     Initializes Version from string, examples: "1", "1.0", "0.2.5"
     */
    public init(stringLiteral version: String) {
        let arr = Version.parseVersion(from: version)
        major = arr[optional: 0] ?? 0
        minor = arr[optional: 1] ?? 0
        patch = arr[optional: 2] ?? 0
    }

    /**
     Transform semantic version in string format to array of integers
     - Parameters:
        - value: semantic version in string format, examples: "1", "1.0", "0.2.5"
     - Returns: array of Integers
     */
    private static func parseVersion(from value: String) -> [Int] {
        return value.replacingOccurrences(of: " ", with: "")
            .split(separator: ".")
            .map { String($0)}
            .map {Int($0) ?? 0}
    }
}

extension Collection {
    subscript(optional idx: Index) -> Iterator.Element? {
        return self.indices.contains(idx) ? self[idx] : nil
    }
}
