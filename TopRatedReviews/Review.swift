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
                  Review(rating: 3, name: "I'm Awesome", title: "Is there more?", body: "It doesn't crash, but I don't get it"),
                  Review(rating: 2, name: "Max", title: "Wanted to like it", body: "Will review it again later"),
                  
                  Review(rating: 1, name: "Jonny", title: "Not great...", body: "Can't figure this one out. Avoid..."),
                  
]


struct Label : UIViewRepresentable {
    typealias UIViewType = UILabel
    
//    var label: LabelType
    
    @Binding var text: String
//    @State var text: String
    
    func makeUIView(context: UIViewRepresentableContext<Label>) -> Label.UIViewType {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }
    
    func updateUIView(_ label: Label.UIViewType, context: UIViewRepresentableContext<Label>) {
        label.text = text
    }
}


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

struct ReviewRow: View {
    @State var review: Review

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
            Text(self.review.name)
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

struct Review_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRow(review: reviewData[0])
    }
}
