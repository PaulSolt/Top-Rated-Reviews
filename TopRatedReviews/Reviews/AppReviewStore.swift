//
//  AppReviewStore.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/8/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import Foundation
import Combine

class AppReviewStore: ObservableObject {
    @Published private(set) var reviews: [Review] = []
    @Published var stats: ReviewStats = ReviewStats(reviews: [])
    
    private let service: AppReviewService
    
    init(service: AppReviewService) {
        self.service = service
    }
    
    func fetchReviews(for appId: String, ordering: AppReviewURL.ReviewOrdering) {
        
        let appURL = AppReviewURL(appId: appId, ordering: ordering)
        
        service.fetchReviews(for: appURL) { result in  // TODO: need [weak self]?
            DispatchQueue.main.async {
                switch result {
                case .success(let reviews):
                    self.reviews = reviews
                    self.stats = ReviewStats(reviews: reviews)
                case .failure(let error):
                    print("Error fetching reviews: \(error)")
                    self.reviews = []
                }
            }
        }
    }
}
