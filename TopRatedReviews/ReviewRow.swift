//
//  Review.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/2/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import SwiftUI

struct ReviewTest: Identifiable, Codable {
    var id = UUID()
    var rating: Int
    var name: String
    var title: String
    var body: String
}

let reviewData = [ReviewTest(rating: 5, name: "Jonny Appleseed", title: "Used for everything", body: "Great app, it really helped me get a lot more done in way less time. I don't know of a better app if you need quick results. Download it and you'll love it!!! and I can go on about this one"),
                  ReviewTest(rating: 4, name: "Sue", title: "Longer Review", body: "Great app, it really helped me get a lot more done in way less time. I don't know of a better app if you need quick results. Download it and you'll love it!!! and I can go on about this one. Great app, it really helped me get a lot more done in way less time. \nI don't know of a better app if you need quick results. Download it and you'll love it!!! and I can go on about this one"),
                  ReviewTest(rating: 3, name: "I'm Awesome", title: "Is there more?", body: "It doesn't crash, but I don't get it"),
                  ReviewTest(rating: 2, name: "Max", title: "Wanted to like it", body: "Will review it again later"),

                  ReviewTest(rating: 1, name: "Jonny", title: "Not great...", body: "Can't figure this one out. Avoid..."),

]





struct ReviewRow: View {
    var review: Review

/*    var body: some View {
//        GeometryReader { geometry in
//            Label(text: self.$review.body)
            Text(self.review.body)
                .lineLimit(Int.max)
//                .frame(width: geometry.size.width - 20)
            
            
//        }

    }*/
    
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
let review = Review(id: "1", author: Author(name: "Bob", uri: URL(string:"")!), versionReviewed: "3.4", rating: 4, title: "Is this working", body: "Yes it is!")


struct Review_Previews: PreviewProvider {
    static var previews: some View {
//        ReviewRow(review: reviewData[0])
        ReviewRow(review: review)
    }
}
