//
//  GCDFilterManager.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 11.06.2022.
//

import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class GCDFilterManager : BaseFilterManager {
    var filterProcessor = GCDFilterProcessor()
    
    override var currentImage: UIImage? {
        didSet {
            if let image = currentImage {
                filterProcessor = GCDFilterProcessor(image: image)
            }
        }
    }
    func prepareImages(_ intencity: Int = 0, completion: @escaping([UIImage?])->Void) {
        let group = DispatchGroup()
        var images: [UIImage?] = .init(repeating: nil, count: filterList.count)
        
        for (index, filterName) in filterList.enumerated() {
            group.enter()
            DispatchQueue.global().async {
                self.filterProcessor.applyFilter(filterName: filterName, value: intencity) { image in
                    images[index] = image
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
    
}

