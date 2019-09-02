//
//  StarRatings.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/2/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import SwiftUI

struct StarRow: View {
    var count: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach((1...count), id: \.self) { index in
                
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.red)
            }
        }
    }
}

struct StarRatings: View {
    @State private var size: CGSize = CGSize(width: 8, height: 8)
    @State var stars: [Int] = [5, 50, 3, 1, 3] {
        mutating didSet {
            numStars = stars.reduce(into: 0, { (result, next) in
                result += next
            })
            print("Stars: \(numStars)")
        }
    }
//    private var starArray: [Int] = [5, 4, 3, 2, 1]
    
    private var numStars: Int = 0
    
    var body: some View {
        
        HStack(alignment: .bottom) {
            
            VStack(alignment: .trailing, spacing: 2) {
                ForEach((1...5), id: \.self) { index in
                    StarRow(count: 6 - index)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                ForEach((1...5), id: \.self) { index in
//                    Text("\(self.stars[index - 1])")
                    Rectangle()
                        .frame(width: CGFloat(self.stars[index - 1]), height: self.size.height)
                        .foregroundColor(Color(white: 0.7))
                    
                    
//                    HStack(alignment: .center, spacing: 0) {
//                        ForEach((0...5), id: \.self) { numStars
//                            Image(systemName: "star.fill")
//                                .resizable()
//                                .frame(width: 8, height: 8)
//                                .foregroundColor(.red)
//                            Image(systemName: "star.fill")
//                                .resizable()
//                                .frame(width: 8, height: 8)
//                                .foregroundColor(.red)
//
//
//
//                        }
//                    }
                }
                
            }
        }.background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(Color(white: 0.9)) // red: 0.3, green: 0.3, blue: 0.3)))
        )
        
    }
}

struct StarRatings_Previews: PreviewProvider {
    static var previews: some View {
        StarRatings()
        //        .environmentObject([])
    }
}
