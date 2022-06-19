//
//  ImageDownloader.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 13.06.2022.
//

import Foundation
import UIKit

enum ImageDownloadError: Error {
    case badImage
}

actor ImageDownloader {
    enum ImageStatus {
        case downloading(_ task: Task<UIImage?, Error>)
        case downloaded(_ image: UIImage?)
    }
    
    var cache: [URL: ImageStatus] = [:]
    
    func doSomeJob() {
        
    }
    
    func image(from url: URL) async throws -> UIImage? {
        if let imageStatus = cache[url] {
            switch imageStatus {
            case .downloading(let task):
                return try await task.value
            case .downloaded(let image):
                return image
            }
        }
        
        let task = Task.detached { [weak self] in
            (try await self?.downloadImage(url: url))
        }
        
        cache[url] = .downloading(task)
        
        do {
            let image = try await task.value
            cache[url] = .downloaded(image)
            return image
        } catch {
            // If an error occurs, we will evict the URL from the cache
            // and rethrow the original error.
            cache.removeValue(forKey: url)
            throw error
        }
    }
    
    private func downloadImage(url: URL) async throws -> UIImage {
        let imageRequest = URLRequest(url: url)
        let (data, imageResponse) = try await URLSession.shared.data(for: imageRequest)
        guard let image = UIImage(data: data), (imageResponse as? HTTPURLResponse)?.statusCode == 200 else {
            throw ImageDownloadError.badImage
        }
        return image
    }
}

