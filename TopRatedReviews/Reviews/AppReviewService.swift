//
//  AppReviewService.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/7/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import Foundation

typealias AppReviewCompletion = (Result<[Review], Error>) -> Void



class AppReviewStore {
    @Published private(set) var reviews: [Review] = []
    
    private let service: AppReviewService
    
    init(service: AppReviewService) {
        self.service = service
    }
    
    func fetchReviews(for appId: String, ordering: AppReviewURL.ReviewOrdering) {
        
        let appURL = AppReviewURL(appId: appId, ordering: ordering)
        
        service.fetchReviews(for: appURL) { result in  // TODO: need [weak self]?
            DispatchQueue.main.async {
                switch result {
                case .success(let reviews):
                    self.reviews = reviews
                case .failure(let error):
                    print("Error fetching reviews: \(error)")
                    self.reviews = []
                }
            }
        }
    }
}


class AppReviewService {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    // Error with too many requests
    static let pageDepthLimitMessage = "CustomerReviews RSS page depth is limited to"
    
    
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
        for _ in 1...10 {
            
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
        
        print("Waiting")
        downloadGroup.notify(queue: DispatchQueue.main) {
                    print("Finished downloading")
                    print("allReviews.count: \(allReviews.count)")
                    
                    let stats = computeStats(allReviews: &allReviews)
                    // TODO: Remove (put into UI)
            //        print(stats)
            //        print(stats.appVersions.count)
            //        for version in stats.sortedAppVersions() {
            //            print("\(version.version) rating: \(version.average)")
            //        }
                    
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

func computeStats(allReviews: inout [Review]) -> ReviewStats {
    
    // TODO: remove duplicate reviews if duplciate pages requested
    var stats = ReviewStats(reviews: allReviews)
    print(stats)
    // Update all reviews with latest version for stats / visualization in UI
    let currentVersion = stats.currentVersion()
    stats.updateCurrentVersion(reviews: &allReviews, currentVersion: currentVersion)
    
    
    return stats
}




