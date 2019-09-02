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
    
//    private var starWidth: CGFloat
//    private var starHeight: CGFloat
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach((1...count), id: \.self) { index in
                
                Image(systemName: "star.fill")
                    .resizable()          // Can't get them to align with resizable/trailing, they center...
                    .aspectRatio(1, contentMode: .fit)
//                    .frame(width: 8, height: 8)
                    .foregroundColor(.red)
            }
        }
    }
}

struct StarRatings: View {
    
    var stars: [Int] = [100, 50, 3, 1, 3] {
        mutating didSet {
            calculateLengths()
        }
    }
    
    private var size: CGSize = CGSize(width: 8, height: 8)
    
    private var averageRating: Double = 5
    
    init() {
        calculateLengths()
    }
    
    private mutating func calculateLengths() {
        totalStars = stars.reduce(0, +)
        
        lengths = []
        for i in 0..<5 {
            let rating: CGFloat = CGFloat(stars[i]) / CGFloat(totalStars)
            lengths.append(rating)
        }
        
        averageRating = 0.0
        for i in 0..<5 {
            //            let rating = stars[i]
            averageRating += (Double(stars[i]) * Double(5 - i))
        }
        averageRating /= Double(totalStars)
    }
    
    private var totalStars = 0
    
    private var ratingFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    private var lengths: [CGFloat] = []
    
    var body: some View {
        
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(ratingFormatter.string(from: NSNumber(value: averageRating)) ?? "INVALID") // TODO: should we do something else for nil values?
                    .font(.largeTitle)
                    .foregroundColor(Color(white: 0.8))
                Text("out of 5")
                    .foregroundColor(Color(white: 0.5))
            }
            VStack(alignment: .trailing, spacing: 2) {
                ForEach((1...5).reversed(), id: \.self) { index in
                    StarRow(count: index)
//
//                    .frame(width: 40, height: 8)
                }
            }
            
            VStack(alignment: .trailing, spacing: 4) {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach((0..<5), id: \.self) { index in
                        HStack {
                            //                        Text("\(self.stars[index])")
                            ZStack(alignment: .leading) {
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
                Text("\(totalStars) Ratings")
                    .foregroundColor(Color(white: 0.8))
            }
            
        }.background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .padding(-20)
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
