//
//  Review.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/2/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import SwiftUI

struct Review: Identifiable, Codable {
    var id = UUID()
    var rating: Int
    var name: String
    var title: String
    var body: String
}

let reviewData = [Review(rating: 5, name: "Jonny Appleseed", title: "Used for everything", body: "Great app, it really helped me get a lot more done in way less time. I don't know of a better app if you need quick results. Download it and you'll love it!!! and I can go on about this one"),
                  Review(rating: 4, name: "Sue", title: "Longer Review", body: "Great app, it really helped me get a lot more done in way less time. I don't know of a better app if you need quick results. Download it and you'll love it!!! and I can go on about this one. Great app, it really helped me get a lot more done in way less time. \nI don't know of a better app if you need quick results. Download it and you'll love it!!! and I can go on about this one"),
                  Review(rating: 3, name: "Jonny Appleseed is Awesome", title: "Is there more?", body: "It doesn't crash, but I don't get it"),
                  Review(rating: 2, name: "Max", title: "Wanted to like it", body: "Will review it again later"),

                  Review(rating: 1, name: "Jonny", title: "Not great...", body: "Can't figure this one out. Avoid..."),

]

struct StarRating: View {
    
    var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index -> Image in
                Image(systemName: (index <= self.rating) ? "star.fill" : "star")
                //                    .foregroundColor(.red)
                //                if index < self.rating {
                //                    Image(systemName: "star.fill")
                //                        .foregroundColor(.red)
                //                } else {
                //                    Image(systemName: "star")
                //                        .foregroundColor(.red)
                //                }
            }.foregroundColor(.red)
        } // .foregroundColor(.red)
    }
}

struct ReviewRow: View {
    var review: Review
    
    var body: some View {
        VStack(alignment: .leading) {
            
            StarRating(rating: review.rating)
            Text(review.name)
                .font(.caption)
            Text(review.title)
                .font(.headline)
            Text(review.body)
                .font(.body)
            //            .lineLimit(nil)
            //                .font(.body)
            
            
        }
        .lineLimit(12)
        .padding()
        //        .background(
        //            RoundedRectangle(cornerRadius: 20, style: .continuous)
        //                .foregroundColor(Color(white: 0.92))
        //        )
        //        .padding()
        
    }
}


// Line wrapping doesn't work well

struct Review_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRow(review: reviewData[0])
    }
}
