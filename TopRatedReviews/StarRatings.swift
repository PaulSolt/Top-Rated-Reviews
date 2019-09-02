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
    //    init(stars: [Int]) {
    //        self.stars = [ 34, 4, 4, 5, 5]
    //    }
    
    var stars: [Int] = [100, 50, 3, 1, 3] {
        mutating didSet {
            calculateLengths()
        }
    }
    //    private var starArray: [Int] = [5, 4, 3, 2, 1]
    private var size: CGSize = CGSize(width: 8, height: 8)
    
    private var numStars: Int = 100
    
    init() {
        print("HI")
        
        
        // total stars - stars
        
        calculateLengths()
    }
    
    private mutating func calculateLengths() {
        numStars = stars.reduce(0, +)
        
        lengths = []
        for i in 0..<5 {
            let rating: CGFloat = CGFloat(stars[i]) / CGFloat(numStars)
            lengths.append(rating)
        }
    }
    
    private var lengths: [CGFloat] = []
    
    var body: some View {
        
        HStack(alignment: .bottom) {
            
            VStack(alignment: .trailing, spacing: 2) {
                ForEach((1...5).reversed(), id: \.self) { index in
                    StarRow(count: index)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                ForEach((0..<5), id: \.self) { index in
                    HStack {
                        //                        Text("\(self.stars[index])")
                        ZStack(alignment: .leading) { //alignment: .center, spacing: 0) {
                            Rectangle()
                                .frame(width: CGFloat(100), height: self.size.height)
                                .foregroundColor(Color(white: 0.4))
                            Rectangle()
                                .frame(width: CGFloat(self.lengths[index]) * 100, height: self.size.height)
                                .foregroundColor(Color(white: 0.8))
                            
                        }
                    }
                }
                
            }
        }.background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .padding(-10)
                .foregroundColor(Color(white: 0.2)) // red: 0.3, green: 0.3, blue: 0.3)))
            
        )
        
    }
}

struct StarRatings_Previews: PreviewProvider {
    static var previews: some View {
        
        StarRatings() // stars: [100, 34, 3, 4, 2])
        //        StarRatings(
        //        StarRatings(stars: [100, 34, 3, 3, 5])
        //        .environmentObject([])
    }
}
