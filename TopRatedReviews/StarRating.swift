//
//  StarRating.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/7/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import SwiftUI

struct StarRating: View {
    var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { index -> Image in
                Image(systemName: (index <= self.rating) ? "star.fill" : "star")
                
                // OR
//                if index < self.rating {
//                    return Image(systemName: "star.fill")
//                } else {
//                    return Image(systemName: "star")
//                    //     .foregroundColor(.red) // NOTE: You can't set foreground in here, must be at ForEach
//                }
            }.foregroundColor(.red)
        }
    }
}

struct StarRating_Previews: PreviewProvider {
    static var previews: some View {
        StarRating(rating: 4)
    }
}
