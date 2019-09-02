//
//  Review.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/2/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import SwiftUI

struct Review: View {
    var body: some View {
        VStack {
            StarRow(count: 5)
            Text("Jonny Appleseed")
                .font(.caption)
            Text("Used for everything")
                .font(.headline)
            Text("Great app, it really helped me get a lot more done in way less time. I don't know of a better app if you need quick results. Download it and you'll love it!!!")
                .font(.body)
            
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(Color(white: 0.8))
        )
        
    }
}

struct Review_Previews: PreviewProvider {
    static var previews: some View {
        Review()
    }
}
