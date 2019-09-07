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
            let appVersion = AppVersion(reviews: reviews, version: version)
            appVersions.append(appVersion)
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
        let versionOutput = appVersions.map { (appVersion) -> String in
            return "\(appVersion)"
        }.joined()
        
        let output =
                "\t\(positiveReviewers) / \(reviewCount) positive reviewers (>=\(Review.positiveReview) stars)\n" +
                "\t\(negativeReviewers) / \(reviewCount) negative reviewers (<=\(Review.negativeReview) stars)\n" +
                "\t\(helpfulReviews) / \(reviewCount) helpful reviews\n" +
                "\t\(qualityReviews) / \(reviewCount) quality reviews with \(Review.qualityReviewCharacterCount) characters\n" +
                versionOutput
        return output
    }
    
}