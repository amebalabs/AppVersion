//
//  AppStoreVersion.swift
//  AppVersion
//

import Foundation

/// Model representing App Store data for the app
public struct AppStoreVersion: Decodable {
    /// Application id, used to uniquely identify app
    public let appId: Int
    /// App icon, 100x100
    public let icon: URL
    /// App size in bytes
    public let size: String
    /// Avarage rating for this version
    public let averageRating: Double?
    /// Ratings count for this version
    public let ratingsCount: Int?
    /// Release date for this version
    public let releaseDate: Date
    /// iOS version required for this version
    public let iOSVersion: String
    /// Release notes
    public let releaseNotes: String
    /// Lates version available in App Store
    public let version: String

    private enum CodingKeys: String, CodingKey {
        case appId = "trackId"
        case icon = "artworkUrl100"
        case size = "fileSizeBytes"
        case averageRating  = "averageUserRatingForCurrentVersion"
        case ratingsCount = "userRatingCountForCurrentVersion"
        case releaseDate = "currentVersionReleaseDate"
        case iOSVersion = "minimumOsVersion"
        case releaseNotes
        case version
    }
}

struct AppStoreAPI: Decodable {
    private enum CodingKeys: String, CodingKey {
        case results
    }

    private let results: [AppStoreVersion]

    static func requestVersion(for region: String?, _ completion: @escaping (AppStoreVersion?, Error?) -> Void) {
        let session = URLSession(configuration: .default)
        // CREATING ENP URL BASE ON BUNDLE-ID AND CONTRY.
        var queryItem = [URLQueryItem(name: "bundleId", value: AppInfo.bundleId)]
        if let regionCode = region {
            queryItem.append(URLQueryItem(name: "country", value: regionCode))
        }
        let endpoint = getLookupURL(with: queryItem)!

        var urlRequest = URLRequest(url: endpoint) //config
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = 10
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData

        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, error)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let response = try decoder.decode(AppStoreAPI.self, from: data)

                guard !response.results.isEmpty else {
                    completion(nil, error)
                    return
                }
                completion(response.results[0], nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
}

extension AppStoreVersion {
    /// Latest available App Store version in Semantic version format
    public var currentVersion: SemanticVersion {
        return SemanticVersion(stringLiteral: version)
    }
    /// Indicates if App Store version compatible with iOS installed on this device
    public var isCompatibleWithOS: Bool {
        return Version(stringLiteral: iOSVersion) <=  Version(stringLiteral: UIDevice.current.systemVersion)
    }
}
