//
//  AppReviewLoader.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/7/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import Foundation


/// Load from File (full file name: "Review.json")
/// IMPORTANT: Add a Build Phase to copy a resource to the Products directory for testing from Xcode
public func loadFilename(fromCurrentDirectory filename: String) throws -> Data {
    
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundle = Bundle(url: currentDirectoryURL)!
    let filenameString = NSString(string: filename)
    let pathComponent = filenameString.deletingPathExtension
    let pathExtension = filenameString.pathExtension
    let fileURL = bundle.url(forResource: pathComponent, withExtension: pathExtension)!
    //    print(fileURL.path)
    
    return try Data(contentsOf: fileURL)
}


func loadMostHelpful() {
    let filename = "MostHelpful.json"
    
    // TODO: Load from Bundle.Resource
    // Get main bundle from app
    let reviewJSONData = try! loadFilename(fromCurrentDirectory: filename)
    //print( String(data: reviewJSONData, encoding: .utf8)!)


    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let results = try! decoder.decode(ReviewResults.self, from: reviewJSONData) // TODO: Cleanup force!
    print(results.appReview.reviews.count)
    
    // TODO: set the current app version

    //let appReviews = results.feed
    let mostHelpfulStats = ReviewStats(reviews: results.appReview.reviews)

    print("Stats for NY Times:\n\(mostHelpfulStats)")
}


// TODO: Create a service that's hot swapable with the interface of the other one
// Or just inject the data into a mock loader
