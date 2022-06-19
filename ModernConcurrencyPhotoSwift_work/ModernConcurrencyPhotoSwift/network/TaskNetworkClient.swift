//
//  TaskNetworkClient.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 19.06.2022.
//

import Foundation

import UIKit

class TaskNetworkClient {
    
    func loadImage(url: String) async throws -> UIImage? {
        if let url = URL(string: url) {
            let loadTask = Task.detached(priority: .background) { [weak self] in
               try? await self?.downloadImage(url:url)
            }
            return await loadTask.value
        }
        return nil
    }

    
    func downloadImage(url: URL) async throws -> UIImage {
        let imageRequest = URLRequest(url: url)
        let (data, imageResponse) = try await URLSession.shared.data(for: imageRequest)
        guard let image = UIImage(data: data), (imageResponse as? HTTPURLResponse)?.statusCode == 200 else {
            throw ImageDownloadError.badImage
        }
        return image
    }
    
    func loadUserImages(forURLs urls: [String]) async throws -> [UIImage?] {
        
        //1. Используем групповую задачу
        
        let userImages: [UIImage?] = try await withThrowingTaskGroup(of: UIImage?.self) {[weak self] group -> [UIImage?] in
            guard let self = self else {return []}
            
            for urlString in urls {
                
                // 2. Добавляем задачу к группе
                
                group.addTask { [weak self] in
                    guard let self = self else {return nil}
                    if let url = URL(string: urlString) {
                        return try await self.downloadImage(url: url)
                    }
                    return nil
                }
            }
            
            var images: [UIImage?] = []
            //3. Ожидаем задачи группы в цикле
            for try await image in group {
                images.append(image)
            }
            
            return images
        }
        
        return userImages
    }
    
    
}

