//
//  IsolatedFilterProcessor.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 19.06.2022.
//

import Foundation
@preconcurrency import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

actor IsolatedFilterProcessor {
    private var currentImage: UIImage? = nil
    private var currentFilter: CIFilter? = nil
    

   let context: CIContext = CIContext()
    
    nonisolated func setupImagePublic(image: UIImage) {
        Task {
        await setupImage(image: image)
        }
    }
    
    nonisolated func setupFilterPublic(filter: String) {
        Task {
        await selectFilter(filter: filter)
        }
    }
    
    private func setupImage(image: UIImage) {
        self.currentImage = image
        if let filter = self.currentFilter {
            let beginImage = CIImage(image: image)
            filter.setValue(beginImage, forKey: kCIInputImageKey)
        }
    }
    
    private func selectFilter(filter: String) {
        self.currentFilter = CIFilter(name: filter)
        if let image = self.currentImage {
            let beginImage = CIImage(image: image)
            self.currentFilter?.setValue(beginImage, forKey: kCIInputImageKey)
        }
    }
    
    func setupParameters(_ baseIntencity: Int = 0) {
        let size = currentImage?.size
        self.currentFilter?.setupParameters(baseIntencity, size)
    }
    
    private func applyProcessing(image: UIImage, filter: String, _ baseIntencity: Int = 0) async throws -> UIImage? {
        setupImage(image: image)
        selectFilter(filter: filter)
        self.setupParameters(baseIntencity)
        guard let filter = currentFilter, let outputImage = filter.outputImage else {return nil}
        return await withCheckedContinuation { continuation in
            if let cgimg = context.createCGImage(outputImage, from: filter.outputImage!.extent) {
                let processedImage = UIImage(cgImage: cgimg)
                continuation.resume(returning: processedImage)
            } else {
                continuation.resume(returning: nil)
            }
        }
    }
    
    nonisolated func applyFilter(image: UIImage, filter: String, value: Int = 0) async -> UIImage? {
        return try? await applyProcessing(image: image, filter: filter, value)
    }
}
