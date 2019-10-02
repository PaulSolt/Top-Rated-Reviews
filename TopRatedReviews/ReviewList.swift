//
//  ReviewList.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/2/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import SwiftUI

struct ReviewList: View {
    //    var reviews: [Review] = appReviewTestData  // Prototype
    @EnvironmentObject var reviewStore: AppReviewStore
    
    var blankVersion = AppVersion(reviews: [], version: "0.0.0")
    
    var body: some View {
        NavigationView {
            VStack {
                
                VStack(alignment: .leading) {
                    Text(AppVersion.allVersions)
                    
                    StarRatingsView(appVersion: reviewStore.stats.allVersions)
                        .padding(.all, 8)
                }.padding(.all, 16)
                
                VStack(alignment: .leading) {
                    Text("Version: \(reviewStore.stats.currentVersion())")
                    StarRatingsView(appVersion: reviewStore.stats.currentAppVersion ?? blankVersion)
                        .padding(.all, 8)
                }.padding(.bottom, 16)
                List {
                    //                List(reviewStore.reviews) { review in
                    ForEach(reviewStore.reviews) { review in
                        
                        ReviewRow(review: review)
                    }
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
        ReviewList()
            .environmentObject(
                AppReviewStore(service: AppReviewService()))
    }
}
