//
//  Review.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/7/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import Foundation

/// App Review and rating from a customer
struct Review: Decodable {
    let id: String
    let author: Author
    let versionReviewed: String
    let rating: Int
    let title: String
    let body: String
    let helpfulReviewVotes: Int  // number of customers who found review helpful
    let totalReviewVotes: Int    // total number of customers who voted on review being helpful (yes/no)

    var currentAppVersion: String? // Set after you find all versions
    
    // Constants
    static let negativeReview = 2
    static let positiveReview = 3
    static let allStarReviewCount = 5
    static let firstTimeReviewCount = 1
    static let qualityReviewCharacterCount = 500
    
    // Someone who rates apps negativily
    var isNegativeReviewer: Bool {
        return rating <= Review.negativeReview
    }
    
    /// Someone who rates apps overwhelmingly positive
    var isPositiveReviewer: Bool {
        return rating >= Review.positiveReview
    }

    ///The customer is the judge if a review is helpful (or still relevant / accurate)
    /// NOTE: This may change over time as apps are updated (or abandoned)
    var isHelpfulReview: Bool {
        let result = helpfulReviewVotes >= (totalReviewVotes - helpfulReviewVotes)
        return result
    }
    
    /// A score to sort reviews by
    /// Will be 0 if there is no feedback on the review
    /// Positive number is an indication of positive reviews outnumbering negative reviews
    /// Magnitude is an indication of how many people agree with review (if it's still relevant as updates happen)
    /// Negative is an indication that review is not good, inaccurate, or out of date with latest app updates (no longer relevant)
    var helpfulReviewScore: Int {
        return helpfulReviewVotes - (totalReviewVotes - helpfulReviewVotes)
    }
    
    /// Scores the helpfulness of the review
    var helpfulReviewPercentage: Double? {
        return (totalReviewVotes == 0) ? nil : (Double(helpfulReviewVotes) / Double(totalReviewVotes))
    }
    
    /// A reviewer that has taken some time to write
    /// FIXME: May want to combine with isHelpfulReview for Customer helpfulness votes to rank quality reviews against each other.
    /// NOTE: There can be fake long stories, which is a trend among kids for App Store reviews
    var isQualityReview: Bool {
        return body.count > Review.qualityReviewCharacterCount
    }
    
    enum ReviewCodingKeys: String, CodingKey {
        case id
        case author
        case versionReviewed = "im:version"
        case rating = "im:rating"
        case title
        case body = "content"
        case helpfulReviewVotes = "im:voteSum"
        case totalReviewVotes = "im:voteCount"
        case feed
        case entry
        case label
    }
    
    /// If currentAppVersion is set, this will compare the two, otherwise it will
    /// default to false. You'll need to populate this field with highest version
    /// string from iterating over all versions in reviews
    var isLatestVersion: Bool {
        if let currentAppVersion = currentAppVersion {
            return versionReviewed == currentAppVersion
        }
        return false
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ReviewCodingKeys.self)
                
        id = try container.decode(ElementLabel.self, forKey: .id).label
        author = try container.decode(Author.self, forKey: .author)
        versionReviewed = try container.decode(ElementLabel.self, forKey: .versionReviewed).label
        rating = Int(try container.decode(ElementLabel.self, forKey: .rating).label)!
        title = try container.decode(ElementLabel.self, forKey: .title).label
        body  = try container.decode(ElementLabel.self, forKey: .body).label
        helpfulReviewVotes = Int(try container.decode(ElementLabel.self, forKey: .helpfulReviewVotes).label)!
        totalReviewVotes = Int(try container.decode(ElementLabel.self, forKey: .totalReviewVotes).label)!
        
        // NOTE: Must set after pulling in all reviews available
        currentAppVersion = nil
    }
    
}

struct ElementLabel: Decodable {
    let label: String
}

struct Author: Decodable {
    let name: String
    let uri: URL
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AuthorCodingKeys.self)
        
        name = try container.decode(ElementLabel.self, forKey: .name).label
        let urlString = try container.decode(ElementLabel.self, forKey: .uri).label
        uri = URL(string: urlString)!
    }
    
    enum AuthorCodingKeys: String, CodingKey {
        case name
        case uri
    }
}

/// Top level structure
struct ReviewResults: Decodable {
    var appReview: AppReview
    
    enum CodingKeys: String, CodingKey {
        case appReview = "feed"
    }
}

struct AppReview: Decodable {
//    var author: Author // FIXME: Apple (iTunes Store) not the actual app author (Where is this app author?)
    var reviews: [Review]
    var id: String      // FIXME: URL?
    var links: ReviewLinks
    var date: String
    
    enum ReviewFeedCodingKeys: String, CodingKey {
        case author
        case reviews = "entry"
        case id
        case date = "updated"
        case links = "link"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ReviewFeedCodingKeys.self)
        // NOTE: reviews array "entry" is missing when no more reviews on page request
        reviews = (try? container.decode([Review].self, forKey: .reviews)) ?? [] // default to empty array
        id = try container.decode(ElementLabel.self, forKey: .id).label
        links = try container.decode(ReviewLinks.self, forKey: .links)

        let dateString = try container.decode(ElementLabel.self, forKey: .date).label
        date = dateString
//        print(dateString)
//        var d = try container.decode(DateLabel.self, forKey: .date).date // FIXME: decode to Date
//        print("Date: \(d)")
//        date = "\(d)"
    }
}

// TODO: Use Date label to get date (special format (ISO8601DateFormatter)
struct DateLabel: Decodable {
    var date: Date

    enum CodingKeys: String, CodingKey {
        case date = "label"
    }
}

// TODO: Parse links if they are relevant (right now I'm not sure they are useful, seems broken links)
struct ReviewLinks: Decodable {
    
}

