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

    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) { //}, appURL: AppReviewURL) {
        self.session = session
        self.decoder = decoder
//        self.appURL = appURL
    }
    
    func fetchReviews(for appURL: AppReviewURL, completion: @escaping AppReviewCompletion) {
        var appURL = appURL
        
        guard let url = URL(string: appURL.path) else {
            preconditionFailure("Cannot make url: \(appURL.path)")
        }
        var allReviews: [Review] = []

        print("URL: \(url)")
        session.dataTask(with: url) { (data, _, error) in
            // NOTE: only request pages 1...10 (more is not supported)
            let downloadGroup = DispatchGroup()
            for _ in 1...10{
                print(appURL.url)
                downloadGroup.enter()
                // request data
                URLSession.shared.dataTask(with: appURL.url) { (data, _, error) in
                    defer {
                        downloadGroup.leave()
                    }
                    if let error = error {
                        fatalError("iTunes Review Error: \(error)")
                        return completion(.failure(AppReviewError.urlSessionError(error)))
                    }
                    guard let data = data else {
//                        fatalError("Error: no data")
                        return completion(.failure(AppReviewError.noData))
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let results = try decoder.decode(ReviewResults.self, from: data)
                        let reviews = results.appReview.reviews
                        print("Downloaded: \(reviews.count) reviews")
                        
                        DispatchQueue.main.async {
                            allReviews.append(contentsOf: reviews)
                            print(allReviews.count)
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
                }.resume()
                appURL = appURL.next
            }

            print("Waiting")
            downloadGroup.wait()
            print("Finished")


            let stats = computeStats(allReviews: &allReviews)
            
            completion(.success(allReviews)) // TODO: Move stats function
            // TODO: Call completion handler
            
        }.resume()
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

    // Update all reviews with latest version for stats / visualization in UI
    let currentVersion = stats.currentVersion()
    stats.updateCurrentVersion(reviews: &allReviews, currentVersion: currentVersion)

    // TODO: Remove (put into UI)
    print(stats)
    print(stats.appVersions.count)
    for version in stats.sortedAppVersions() {
        print("\(version.version) rating: \(version.average)")
    }
    return stats
}




