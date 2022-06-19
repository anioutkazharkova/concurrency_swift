//
//  BaseFilterManager.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 11.06.2022.
//

import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class BaseFilterManager : @unchecked Sendable {
    var currentImage: UIImage? = nil
    var currentFilter: CIFilter? = nil
    var context: CIContext? = nil
    
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
    
    
    func setupImage(image: UIImage) {
        self.currentImage = image
        if let filter = currentFilter {
            let beginImage = CIImage(image: image)
            filter.setValue(beginImage, forKey: kCIInputImageKey)
        }
    }
    
    func selectFilter(index: Int) {
        context = CIContext()
        currentFilter = CIFilter(name: filterList[index])
        if let image = self.currentImage, let filter = currentFilter {
            let beginImage = CIImage(image: image)
            filter.setValue(beginImage, forKey: kCIInputImageKey)
        }
    }
}

extension CIFilter {
    func setupParameters(_ baseIntencity: Int = 0, _ size: CGSize? = nil) {
        let inputKeys = self.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            let intensity = baseIntencity
            
            setValue(intensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) {
            let intensity = baseIntencity * 200
            setValue(intensity, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) {
            let intensity = baseIntencity * 10
            setValue(intensity, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) {
            guard let size = size  else {return}
            setValue(CIVector(x: size.width / 2, y: size.height / 2), forKey: kCIInputCenterKey)
            
        }
    }
    
    func setupImage(image: UIImage) {
        let beginImage = CIImage(image: image)
        setValue(beginImage, forKey: kCIInputImageKey)
    }
    
    static func create(_ name: String)->CIFilter{
        return CIFilter(name: name)!
    }
}
