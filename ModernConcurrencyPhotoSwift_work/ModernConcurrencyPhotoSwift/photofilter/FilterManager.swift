//
//  FilterManager.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 11.06.2022.
//

import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins


final class FilterManager: BaseFilterManager {
    var filterProcessor = IsolatedFilterProcessor()
    
    
    
    func prepareImages(_ intencity: Int = 0) async -> [UIImage]  {
        
        var images = [UIImage]()
        await withTaskGroup(of: UIImage.self) { [weak self] group in
            for filter in filterList {
                group.addTask { [weak self] in
                    let image = await self?.filterProcessor.applyFilter(image: self?.currentImage ?? UIImage(), filter: filter, value: intencity)
                    return image ?? UIImage()
                }
            }
            for await image in group {
                images.append(image)
            }
        }
        return images
    }
}
