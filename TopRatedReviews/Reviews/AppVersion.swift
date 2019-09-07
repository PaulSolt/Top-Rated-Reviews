//
//  AppVersion.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/7/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import Foundation

struct AppVersion: CustomStringConvertible {
    var version: String
    var oneStar: Int = 0
    var twoStars: Int = 0
    var threeStars: Int = 0
    var fourStars: Int = 0
    var fiveStars: Int = 0
    var average: Double = 0
    var totalRatings: Int = 0
    var reviews: [Review] = []
    
    // Constants
    static let allVersions = "All Versions"
    
    init(reviews: [Review], version: String) {
        self.version = version
        updateStats(reviews: reviews)
    }
    
    mutating func clearStats() {
        oneStar = 0
        twoStars = 0
        threeStars = 0
        fourStars = 0
        fiveStars = 0
        average = 0.0
        totalRatings = 0
        reviews = []
    }
    
    func isCurrentVersion(_ review: Review) -> Bool {
        return review.versionReviewed == version
    }
    
    func isAllVersions() -> Bool {
        return version == AppVersion.allVersions
    }
    
    mutating func updateStats(reviews: [Review]) {
        clearStats()
        var ratingsSum = 0
        for review in reviews {
            if isCurrentVersion(review) || isAllVersions() {
                self.reviews.append(review)
                
                if review.rating == 1 {
                    oneStar += 1
                }
                if review.rating == 2 {
                    twoStars += 1
                }
                if review.rating == 3 {
                    threeStars += 1
                }
                if review.rating == 4 {
                    fourStars += 1
                }
                if review.rating == 5 {
                    fiveStars += 1
                }
                ratingsSum += review.rating
                totalRatings += 1
            }
        }
        average = Double(ratingsSum) / Double(totalRatings)
    }
    
    var description: String {
        let output =
            "Version: \(version)\n" +
            "\t5 Star: \(fiveStars)\n" +
            "\t4 Star: \(fourStars)\n" +
            "\t3 Star: \(threeStars)\n" +
            "\t2 Star: \(twoStars)\n" +
            "\t1 Star: \(oneStar)\n" +
            String(format: "\tAverage: %0.2f, \(totalRatings) total ratings\n", average, totalRatings)
        return output
    }
}
