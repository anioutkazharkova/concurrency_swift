//
//  FilterGroupProcessor.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 19.06.2022.
//

import Foundation
@preconcurrency import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

actor FilterGroupProcessor {
    private var currentImage: UIImage? = nil
    
    private var processed: [String: UIImage] = [String:UIImage]()
    
    let context: CIContext = CIContext()
    
    lazy var filterList = ["CISepiaTone",
                           "CIPhotoEffectChrome",
                           "CITwirlDistortion",
                           "CIUnsharpMask",
                           "CIVignette",
                           "CIColorMonochrome",
                           "CIGaussianBlur",
                           "CIBumpDistortion",
                           "CIPhotoEffectFade",
                           "CIPhotoEffectInstant",
                           "CIPhotoEffectMono",
                           "CIPhotoEffectNoir",
                           "CIPhotoEffectProcess",
                           "CIPhotoEffectTonal",
                           "CIPhotoEffectTransfer"]
    
    init(){}
    
    init(image: UIImage) {
        self.currentImage = image
    }
    
    func prepareImages(_ intencity: Int = 0) async -> [UIImage]  {
        var images = [UIImage]()
        await withTaskGroup(of: UIImage.self) { [weak self] group in
            for filter in filterList {
                group.addTask { [weak self] in
                    let image = try? await self?.applyProcessing(filterName: filter, intencity)
                    return image ?? UIImage()
                }
            }
            for await image in group {
                images.append(image)
            }
        }
        return images
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
    
}
