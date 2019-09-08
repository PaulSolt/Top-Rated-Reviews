//
//  ReviewList.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/2/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import SwiftUI

struct ReviewList: View {
//    var reviews: [Review] = []  // Prototype
    @EnvironmentObject var reviewStore: AppReviewStore
    
    var body: some View {
        NavigationView {
            
            VStack {
                List(reviewStore.reviews) { review in
                    ReviewRow(review: review)
                }
            }.navigationBarTitle(Text("Reviews"))
        }.onAppear {
            self.fetch()
            
            // TODO: Show star rating
            // TODO: update star rating
        }
    }
    
    private func fetch() {
        reviewStore.fetchReviews(for: "284862083", ordering: .mostHelpful) // NYTimes
    }
}

struct ReviewList_Previews: PreviewProvider {
    static var previews: some View {
//        ReviewList(reviews: appReviewData) // prototype
        ReviewList()
            .environmentObject(
                AppReviewStore(service: AppReviewService()
            ))
    }
}
