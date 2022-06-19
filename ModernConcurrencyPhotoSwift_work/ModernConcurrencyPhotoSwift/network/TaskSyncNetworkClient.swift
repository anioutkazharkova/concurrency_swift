//
//  TaskNetworkClient.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 19.06.2022.
//

import Foundation
import UIKit

//1. Финалим класс
//2. Sendable для thread-safe
final class TaskSyncNetworkClient : Sendable {
    
    //3 Actor для синхронизации
    let downloader = ImageDownloader()
    
    func loadUserImages(forURLs urls: [String]) async throws -> [UIImage?] {
        //downloader.cache[URL(string: urls[0])!] = .downloaded(UIImage())
        //4 Групповая задача
        let userImages: [UIImage?] = try await withThrowingTaskGroup(of: UIImage?.self) {[weak self] group -> [UIImage?] in
            guard let self = self else {return []}
            for urlString in urls {
                //5. Присоединяем задачу к группе
                group.addTask { [self] in
                    if let url = URL(string: urlString) {
                        return try await self.downloader.image(from: url)
                    }
                    return nil
                }
            }

            var images: [UIImage?] = []
            //6. Ожидаем задачи группы в цикле
            for try await image in group {
                images.append(image)
            }

            return images
        }

        return userImages
    }
}

