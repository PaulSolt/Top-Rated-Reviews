//
//  ReviewStats.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/7/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import Foundation

struct ReviewStats: CustomStringConvertible {
    var negativeReviewers: Int = 0
    var positiveReviewers: Int = 0
    var qualityReviews: Int = 0
    var helpfulReviews: Int = 0
    var reviewCount: Int = 0
    var appVersions: [AppVersion] = []
    var allVersions: AppVersion = AppVersion(reviews: [], version: AppVersion.allVersions)
    
    init(reviews: [Review]) {
        updateStats(reviews: reviews)
    }

    mutating func clearStats() {
        negativeReviewers = 0
        positiveReviewers = 0
        qualityReviews = 0
        helpfulReviews = 0
        reviewCount = 0
        appVersions = []
        allVersions = AppVersion(reviews: [], version: AppVersion.allVersions)
    }
    
    mutating func updateStats(reviews: [Review]) {
        clearStats()
        var versions: [String : Int] = [:]
        
        for review in reviews {
            if review.isNegativeReviewer {
                negativeReviewers += 1
            }
            if review.isPositiveReviewer {
                positiveReviewers += 1
            }
            if review.isQualityReview {
                qualityReviews += 1
            }
            if review.isHelpfulReview {
                helpfulReviews += 1
            }

            incrementVersion(review.versionReviewed, versions: &versions)
            incrementVersion(AppVersion.allVersions, versions: &versions)
        }
        reviewCount = reviews.count
        
        versions.forEach { (version: String, count: Int) in
            if version == AppVersion.allVersions {
                allVersions = AppVersion(reviews: reviews, version: version)
            } else {
                let appVersion = AppVersion(reviews: reviews, version: version)
                appVersions.append(appVersion)
            }
        }
        
    }
    
    private func incrementVersion(_ version: String, versions: inout [String : Int]) {
        if let count = versions[version] {
            versions[version] = count + 1
        } else {
            versions[version] = 1
        }
    }
    
    var description: String {
        
        let output =
                "\t\(positiveReviewers) / \(reviewCount) positive reviewers (>=\(Review.positiveReview) stars)\n" +
                "\t\(negativeReviewers) / \(reviewCount) negative reviewers (<=\(Review.negativeReview) stars)\n" +
                "\t\(helpfulReviews) / \(reviewCount) helpful reviews\n" +
                "\t\(qualityReviews) / \(reviewCount) quality reviews with \(Review.qualityReviewCharacterCount) characters\n" +
                currentVersionOutput
                
        return output
    }
    
    var versionsOutput: String {
        let versionOutput = appVersions.map { (appVersion) -> String in
            return "\(appVersion)"
        }.joined()
        return versionOutput
    }
    
    var currentVersionOutput: String {
        if let appVersion = currentAppVersion {
            return "\(appVersion)"
        } else {
            return "Missing current version"
        }
    }
    
    // TODO: Move into AppVersion class

    func sortedVersions() -> [String] {
        var versions = appVersions.map { $0.version }
        versions.removeAll() { $0 == AppVersion.allVersions }

        versions.sort { (v1: String, v2: String) -> Bool in
            v1.rawVersion.isVersion(lessThanOrEqualTo: v2.rawVersion)
        }
        return versions
    }

    /// Sorts and returns latest version
    func currentVersion() -> String {
        let versions = sortedVersions()
        return versions.last ?? "" // FIXME: return optional?
    }

    /// Used to set the currentVersion on the review data, so that the UI can show a flag if
    /// review is current or out of date (We don't have a timestamp in this API)
    /// TODO: Need to fix the issue with Reviews in versions not getting currentVersion set (does this work?)
    mutating func updateCurrentVersion(reviews: inout [Review], currentVersion: String) {
        for i in 0 ..< reviews.count {
            reviews[i].currentAppVersion = currentVersion
        }

        updateStats(reviews: reviews)
    }

    func sortedAppVersions() -> [AppVersion] {
        return appVersions.sorted { (a1, a2) -> Bool in
            a1.version.rawVersion.isVersion(lessThanOrEqualTo: a2.version.rawVersion)
        }
    }
    
    var currentAppVersion: AppVersion? {
        return sortedAppVersions().last
    }
}
