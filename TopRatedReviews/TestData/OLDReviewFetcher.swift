//
//  ReviewFetcher.swift
//  TopRatedReviews
//
//  Created by Paul Solt on 9/3/19.
//  Copyright © 2019 Paul Solt. All rights reserved.
//

import UIKit
import Combine

class MenuCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    
    var subscriber: AnyCancellable?
    
    override func  prepareForReuse() {
        super.prepareForReuse()
        
        itemImageView.image = nil
        
        subscriber?.cancel() // prevents images from being placed on wrong cell
    }
    
    
}


class ReviewFetcher: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    //    var pub = DataTaskPublisher()
    
    
    func download() {
        
        
        
        
    }
    
    
    enum PubSocketError: Error {
        case invalidServerResponse
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuCell
        
        let url = URL(string: "abc.com")!
        var request = URLRequest(url: url)
        request.allowsConstrainedNetworkAccess = false // what's the default
        
        //        cell.subscriber =
        _ = URLSession.shared.dataTaskPublisher(for: request)
//            .tryCatch { error -> URLSession.DataTaskPublisher in
//
//                guard error.networkUnavailableReason == .constrained else {
//                    throw error
//                }
//                return URLSession.shared.dataTaskPublisher(for: url)
//            }
            .tryMap { data, response -> UIImage in
                
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200,
                    let image = UIImage(data: data) else {
                        throw PubSocketError.invalidServerResponse
                }
                return image
            }
            .replaceError(with: UIImage()) // placeholder image
//            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
//                        .assign(to: \.image, on: self)
                        .assign(to: \.itemImageView.image, on: cell)
//            .sink { (image: UIImage) in
//                print("Image!")
//                cell.itemImageView.image = image
//            }
        
        ////            .sink(receiveValue: { (image) in
        ////                print("Image: \(image)")
        ////            })
        //        //        .eraseToAnyPublisher()
        
        
        return cell
    }
    
    var image: UIImage = UIImage()
    
    func adaptiveLoader(regularURL: URL, lowDataURL: URL) -> AnyPublisher<Data, Error> {
        
        var request = URLRequest(url: regularURL)
        request.allowsConstrainedNetworkAccess = false
        return URLSession.shared.dataTaskPublisher(for: request)
            
            .tryCatch { error -> URLSession.DataTaskPublisher in
                guard error.networkUnavailableReason == .constrained else {
                    throw error
                }
                return URLSession.shared.dataTaskPublisher(for: lowDataURL)
        }
        .tryMap { data, response -> Data in
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    throw PubSocketError.invalidServerResponse
            }
            return data
        }
        .eraseToAnyPublisher()
    }
    
    
    
}

