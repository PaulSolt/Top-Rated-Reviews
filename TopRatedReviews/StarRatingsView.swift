//
//  StarRatingsView.swift
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
                    .resizable()          // Can't get them to align with resizable/trailing, they center...
                    .frame(width: 8, height: 8)
                    .foregroundColor(.red)
            }
        }
    }
}

struct StarRatingsView: View {
    
    // TODO: Extract model

    var appVersion: AppVersion {
        mutating didSet {
//            if appVersion != nil {
            print("calculate app Versions set")
                calculateLengths()
//            }
        }
    }
    
//    private var stars: [Int] = [100, 50, 3, 1, 3] {
//        mutating didSet {
//            calculateLengths()
//        }
//    }
    
    private var size: CGSize = CGSize(width: 8, height: 8)
    
    private var averageRating: Double = 5
    
    init(appVersion: AppVersion) {
        self.appVersion = appVersion
        calculateLengths()
    }
    
    private var totalStars = 0

    private mutating func calculateLengths() {
        print("Star view: \(appVersion)")
        totalStars = appVersion.totalRatings
//        totalStars = stars.reduce(0, +)
        guard totalStars > 0 else {
            lengths = [0, 0, 0, 0, 0]
            averageRating = 0
            return
        }
        // TODO: support more than 5 stars
        
        lengths = []
        for i in 0..<5 {
            print("stars[\(i)]: \(appVersion.stars[i])")
            let rating: CGFloat = CGFloat(appVersion.stars[i]) / CGFloat(totalStars)
            lengths.append(rating)
        }
        
        print("Lengths: \(lengths)")
        print("Total stars: \(totalStars)")
        averageRating = 0.0
        for i in 0..<5 {
            //            let rating = stars[i]
            averageRating += (Double(appVersion.stars[i]) * Double(5 - i))
        }
        averageRating /= Double(totalStars)
    }
    
    
    private var ratingFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    var averageRatingFormatted: String {
        return ratingFormatter.string(from: NSNumber(value: averageRating)) ?? "0.0"
    }
    
    private var lengths: [CGFloat] = []
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(averageRatingFormatted)
                    .font(.largeTitle)
                    .foregroundColor(Color(white: 0.8))
                Text("out of 5")
                    .foregroundColor(Color(white: 0.5))
            }
            VStack(alignment: .trailing, spacing: 2) {
                ForEach((1...5).reversed(), id: \.self) { index in
                    StarRow(count: index)
                }
            }
            
            VStack(alignment: .trailing, spacing: 4) {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach((0..<5), id: \.self) { index in // TODO: support more than 5 stars (use lengths?)
                        HStack {
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


let appVersionTestData = AppVersion(reviews: appReviewTestData, version: "2.0.1")

struct StarRatings_Previews: PreviewProvider {
    static var previews: some View {
        
        StarRatingsView(appVersion: appVersionTestData) // stars: [100, 34, 3, 4, 2])
        //        StarRatings(
        //        StarRatings(stars: [100, 34, 3, 3, 5])
        //        .environmentObject([])
    }
}
