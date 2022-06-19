//
//  GCDFilterProcessor.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 19.06.2022.
//

import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class GCDFilterProcessor {
    private var currentImage: UIImage? = nil
    
    private var processed: [String: UIImage] = [String:UIImage]()
    
    let context: CIContext = CIContext()
    
    init(){}
    
    init(image: UIImage) {
        self.currentImage = image
    }
    
    
    private func applyProcessing(filterName: String, _ baseIntencity: Int = 0, completion: @escaping(UIImage?)->Void)  {
        let filter = CIFilter.create(filterName)
        if let image = self.currentImage {
            filter.setupImage(image: image)
        }
        filter.setupParameters(baseIntencity, self.currentImage?.size)
        guard let outputImage = filter.outputImage else {
            completion(nil)
            return}
        if let cgimg = context.createCGImage(outputImage, from: filter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.addImage(filter: filterName, image: processedImage)
            completion(processedImage)
        } else {
            completion(nil)
        }
    }
    
    func addImage(filter: String, image: UIImage) {
        self.processed[filter] = image
    }
    
    func applyFilter(filterName: String, value: Int = 0, completion: @escaping(UIImage?)->Void){
        applyProcessing(filterName: filterName, value, completion: completion)
    }
}
