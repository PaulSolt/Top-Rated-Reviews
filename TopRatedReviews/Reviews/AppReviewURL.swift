//
//  AppReviewURL.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/7/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import Foundation

enum ReviewOrdering: String {
    case mostHelpful = "mosthelpful"
    case mostRecent = "mostrecent"
}

/// Used to create URLs to request pages for an app id
/// IMPORTANT:
///     - Current responses are limited to pages 1-10 pages (500 max reviews) for either search term
///     - You can get close to 1000 reviews by combining both review orderings and removing duplicates
struct AppReviewURL: Equatable {
    
    let id: String
    let page: Int
    var ordering: ReviewOrdering
    
    // constants
    static let firstPage = 1
    
    /// IMPORTANT: Starting page is 1, max pages is 10 with CustomerReviews API
    /// NOTE: I'm not sure if there's any other review sort options that work, or if there's another public/open API with more data
    /// NOTE: Apple Affiliate partner has DB access which gives you all the data (but you need to have a server to host / manage)
    init(appId id: String, page: Int = 1, ordering: ReviewOrdering = .mostHelpful) {
        self.id = id
        self.page = max(page, AppReviewURL.firstPage)
        self.ordering = ordering
    }

    var next: AppReviewURL {
        return AppReviewURL(appId: id, page: page + 1, ordering: ordering)
    }
    
    var previous: AppReviewURL {
        let previousPage = max(page - 1, AppReviewURL.firstPage)
        return AppReviewURL(appId: id, page: previousPage, ordering: ordering)
    }
    
    var path: String {
        // FIXME: Does URLComponents allow building out components? I know I can do queries
        return "https://itunes.apple.com/us/rss/customerreviews/page=\(page)/id=\(id)/sortby=\(ordering)/json"
    }
    
    var url: URL? {
        return URL(string: path)
    }
}
