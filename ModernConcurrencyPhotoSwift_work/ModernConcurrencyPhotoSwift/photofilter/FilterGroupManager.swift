//
//  FilterGroupManager.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 19.06.2022.
//

import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins


final class FilterGroupManager {
    var filterProcessor = FilterGroupProcessor()
    
    var currentImage: UIImage? {
        didSet {
            if let image = currentImage {
                filterProcessor = FilterGroupProcessor(image: image)
            }
        }
    }
    
    func prepareImages(_ intencity: Int = 0) async -> [UIImage]  {
        if let image = self.currentImage {
            filterProcessor = FilterGroupProcessor(image: image)
        }
        return await filterProcessor.prepareImages(intencity)
    }
    
}
