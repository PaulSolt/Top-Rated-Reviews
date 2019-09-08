//
//  ReviewList.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/2/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import SwiftUI

struct ReviewList: View {
    var reviews: [Review] = []  // Prototype
    
    var body: some View {
        NavigationView {
            Text("HELLO TRY SWIFT")
        }.onAppear {
            self.fetch()
            
            // TODO: Show star rating
            // TODO: update star rating
        }
    }
    
    private func fetch() {
//        reviewStore.fetchReviews(for: "284862083", ordering: .mostHelpful) // NYTimes
    }
}

struct ReviewList_Previews: PreviewProvider {
    static var previews: some View {
        ReviewList()
    }
}
