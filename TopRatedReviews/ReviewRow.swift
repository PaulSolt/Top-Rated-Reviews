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
                .lineLimit(Int.max)
            
            Text(self.review.body)
                .font(.body)
                .lineLimit(Int.max)
                        
        }
        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 20, style: .continuous)
//                .foregroundColor(Color(white: 0.92))
//        )
//                .padding()
    
    }
}


// Line wrapping doesn't work well
let appReviewTestData = [Review(id: "1",
                    author: Author(name: "Bob", uri: URL(string:"apple.com")!),
                    versionReviewed: "3.4",
                    rating: 4,
                    title: "Is this working",
                    body: "This is the app I spend the most time with, hands down. The content is top-notch: succinct, trustworthy, professional. It’s such a breath of fresh air compared to the sensationalism and shoddy reporting we’re exposed to on social media. I spend 1/2 to an hour every night reading through the Top Stories tab, then finish up with their one-minute crossword.\n\nAs for the app itself, I don’t understand all the 1-Star reviews; I’ve had zero problems with it, and just can’t fathom how one could rate an app ONE star because the app has ads. It’s a newspaper folks, they have to support themselves somehow right? I would actually rate this app higher if I could just based on the fact that their ads are relatively tasteful and not CPU or bandwidth-hogging, or full-screen takeovers. I’ve really enjoyed some of the multimedia stories like the long-scrolling, annotated video graphic of Greenland’s melting ice park. Really, really love this app"),
Review(id: "2",
author: Author(name: "Sue", uri: URL(string:"apple.com")!),
versionReviewed: "3.9",
rating: 2,
title: "Does note work!",
    body: "I don't like this app"),
Review(id: "3",
author: Author(name: "Mike", uri: URL(string:"apple.com")!),
versionReviewed: "3.4",
rating: 5,
title: "I LOVE this app!!!",
body: "I wish more developers made apps like this one!")]

struct Review_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRow(review: appReviewTestData[0])
    }
}
