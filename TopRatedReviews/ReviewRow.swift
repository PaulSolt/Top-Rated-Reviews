//
//  Review.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/2/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import SwiftUI

struct ReviewRow: View {
    var review: Review
    
    var body: some View {
        VStack(alignment: .leading) {
            
            StarRating(rating: self.review.rating)
            Text(self.review.author.name)
                .font(.caption)
            Text(self.review.title)
                .font(.headline)
            
            Text(self.review.body)
                .font(.body)
                .lineLimit(Int.max) // 10)
                        
        }
        .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 20, style: .continuous)
//                        .foregroundColor(Color(white: 0.92))
//                )
//                .padding()
    
    }
}


// Line wrapping doesn't work well
let appReviewData = [Review(id: "1",
                    author: Author(name: "Bob", uri: URL(string:"")!),
                    versionReviewed: "3.4",
                    rating: 4,
                    title: "Is this working",
                    body: "Yes it is!")]

struct Review_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRow(review: appReviewData[0])
    }
}
