//
//  FilterProcesor.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 13.06.2022.
//

import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins



actor FilterProcessor {
    private var currentImage: UIImage? = nil
    
    private var processed: [String: UIImage] = [String:UIImage]()
    
    let context: CIContext = CIContext()
    
    init(){}
    
    init(image: UIImage) {
        self.currentImage = image
    }
    
    private func applyProcessing(filterName: String, _ baseIntencity: Int = 0) async throws -> UIImage? {
        let filter = CIFilter.create(filterName)
        if let image = self.currentImage {
            filter.setupImage(image: image)
        }
        filter.setupParameters(baseIntencity, self.currentImage?.size)
        guard let outputImage = filter.outputImage else {return nil}
        return await withCheckedContinuation { continuation in
            autoreleasepool {
            if let cgimg = context.createCGImage(outputImage, from: filter.outputImage!.extent) {
                let processedImage = UIImage(cgImage: cgimg)
                self.addImage(filter: filterName, image: processedImage)
                continuation.resume(returning: processedImage)
            } else {
                continuation.resume(returning: nil)
            }
            }
        }
    }
    
    func addImage(filter: String, image: UIImage) {
        self.processed[filter] = image
    }
    
   @Sendable func applyFilter(filterName: String, value: Int = 0) async -> UIImage? {
        return try? await applyProcessing(filterName: filterName, value)
    }
}

