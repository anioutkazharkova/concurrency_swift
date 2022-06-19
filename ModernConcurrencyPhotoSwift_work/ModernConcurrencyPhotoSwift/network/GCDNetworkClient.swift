//
//  GCDNetworkClient.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 11.06.2022.
//

import Foundation

class GCDNetworkClient {
    
    func loadImage(url: String, completion: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            var image: Data?
            if let url = URL(string: url) {
                if let data = try? Data(contentsOf: url) {
                    image = data
                }
            }
            DispatchQueue.main.async {
            completion(image)
            }
        }
    }
    
    
    func images(forURLs urls: [String], completion: @escaping ([Data?]) -> Void) {
        let group = DispatchGroup()
        var images: [Data?] = .init(repeating: nil, count: urls.count)
        
        for (index, urlString) in urls.enumerated() {
            group.enter()
            DispatchQueue.global().async {
                var image: Data?
                if let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        image = data
                    }
                }
                images[index] = image
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
}
