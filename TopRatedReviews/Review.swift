//
//  Review.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/2/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import SwiftUI

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

struct Review: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            StarRating(rating: 5)
            Text("Jonny Appleseed")
                .font(.caption)
            Text("Used for everything")
                .font(.headline)
            Text("Great app, it really helped me get a lot more done in way less time. I don't know of a better app if you need quick results. Download it and you'll love it!!! and I can go on about this one")
                .font(.body)
//            .lineLimit(nil)
//                .font(.body)
            
            
        }
        .lineLimit(10)
        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 20, style: .continuous)
//                .foregroundColor(Color(white: 0.92))
//        )
//        .padding()
        
    }
}



struct Review_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        List {
            Review()
        }
        }
    }
}
