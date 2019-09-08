//
//  ReviewList.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/2/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import SwiftUI

class AppReviewStore: ObservableObject {
    @Published private(set) var reviews: [Review] = []
    
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
                case .failure(let error):
                    print("Error fetching reviews: \(error)")
                    self.reviews = []
                }
            }
        }
    }
}


struct ReviewList: View {
    @EnvironmentObject var reviewStore: AppReviewStore

    
    var body: some View {
        List(reviewStore.reviews) { review in
            ReviewRow(review: review)
        }
    }
}

struct ReviewList_Previews: PreviewProvider {
    static var previews: some View {
        ReviewList()
    }
}
