//
//  AppReviewService.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/7/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import Foundation

typealias AppReviewCompletion = (Result<[Review], Error>) -> Void

class AppReviewService {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    // Error with too many requests
    static let pageDepthLimitMessage = "CustomerReviews RSS page depth is limited to"
    static let maxPageCount = 1 // 10
    
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
        //        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func fetchReviews(for appURL: AppReviewURL, completion: @escaping AppReviewCompletion) {
        var appURL = appURL
        
        guard let url = appURL.url else {
            preconditionFailure("Cannot make url: \(appURL.path)")
        }
        var allReviews: [Review] = []
        
        print("URL: \(url)")
        // NOTE: only request pages 1...10 (more is not supported)
        let downloadGroup = DispatchGroup()
        for _ in 1...AppReviewService.maxPageCount {
            
            downloadGroup.enter()
            // request data
            guard let url = appURL.url else {
                print("Error: AppURL is invalid: \(appURL)")
                return
            }
            print(url)
            
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                print("Started")
                defer {
                    downloadGroup.leave()
                }
                if let error = error {
                    return completion(.failure(AppReviewError.urlSessionError(error)))
                }
                guard let data = data else {
                    return completion(.failure(AppReviewError.noData))
                }
                
                do {
                    //                        let decoder = JSONDecoder()
                    let results = try self.decoder.decode(ReviewResults.self, from: data)
                    let reviews = results.appReview.reviews
                    print("Downloaded: \(reviews.count) reviews")
                    
                    DispatchQueue.main.async {
                        allReviews.append(contentsOf: reviews)
                        completion(.success(allReviews))
                    }
                } catch {
                    print("Error decoding Reviews: \(error)")
                    // Attempt to read message
                    
                    if let jsonResponse = String(data: data, encoding: .utf8) {
                        if jsonResponse.starts(with: AppReviewService.pageDepthLimitMessage) {
                            print("TESTError: Max number of pages requested: \(jsonResponse)") // TODO: remove
                            completion(.failure(
                                AppReviewError.maxPageDepthLimit("\(jsonResponse)")))
                        } else {
                            print("TESTError Unknown: \(jsonResponse)") // TODO: remove
                            completion(.failure(
                                AppReviewError.decodeError("Unexpected response: \(jsonResponse)")))
                        }
                    } else {
                        completion(.failure(                                                          AppReviewError.invalidResponse))
                    }
                }
            }
            task.resume()
            appURL = appURL.next
        }
        
        downloadGroup.notify(queue: DispatchQueue.main) {
            print("allReviews.count: \(allReviews.count)")
            completion(.success(allReviews)) // TODO: Move stats function
            
        }
    }
}


enum AppReviewError: Error {
    case maxPageDepthLimit(String)
    case decodeError(String)
    case noData
    case urlSessionError(Error)
    case apiError(String)
    case invalidResponse
}





