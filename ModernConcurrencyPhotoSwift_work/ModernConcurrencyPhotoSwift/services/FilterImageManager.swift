//
//  FilterImageManager.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class FilterImageManager: NSObject {
    static let sharedInstance = FilterImageManager()
    
    var selectedFilter: ColorFilter = ColorFilter(color: .red)
    private var sense: CGFloat = 0.15
    
    private var workImage: UIImage?
    var filters=[ColorFilter] ()
    
    private let ciContext = CIContext(options: nil)
    private var _contextFast: CIContext?
    
    private var ciContextFast: CIContext {
        if (_contextFast == nil) {
            if  let openGLContext = EAGLContext(api: EAGLRenderingAPI.openGLES2) {
                _contextFast = CIContext(eaglContext: openGLContext, options: [CIContextOption.workingColorSpace: NSNull()])
            }
        }
        return _contextFast!
    }
    
    func setupFilter(image: UIImage) {
        self.workImage = image
        self.filters =   [ColorFilter(color: .red),
                          ColorFilter(color: .yellow),
                          ColorFilter(color: .green),
                          ColorFilter(color: .aqua),
                          ColorFilter(color: .blue),
                          ColorFilter(color: .purple)]
        selectedFilter = self.filters[0]
    }
    
    func setupFilter(image: UIImage, with color: UIColor) {
        self.workImage = image
        self.filters = [ColorFilter(color: color.colorGroup)]
        selectedFilter = self.filters[0]
    }
    
    func setupFilter(image: UIImage, with color: Colors) {
        self.workImage = image
        self.filters = [ColorFilter(color: color)]
        selectedFilter = self.filters[0]
    }
    
    func changeFilter(filter: ColorFilter) {
        let current = filters.filter {$0.defaultColor == filter.defaultColor}.first
        current?.selectedHue = filter.selectedHue
        current?.selectedSat = filter.selectedSat
        current?.selectedLum = filter.selectedLum
    }
    
    func selectFilter(color: Colors) {
        let current = filters.filter {$0.defaultColor == color}.first
        if current != nil {
            self.selectedFilter = current!
        }
    }
    
    func selectFilter(index: Int) {
        self.selectedFilter = filters[index]
    }
    
    func reset() {
        self.workImage = nil
        self.filters = [ColorFilter]()
    }
    
    //Применение фильтра с установленными сдвигами
    func apply() -> UIImage? {
        let ciFilter = AdvHSLFilter()
        if let image = workImage, let ci = CIImage(image: image) {
            ciFilter.inputImage = ci
        }
        for f in filters {
            ciFilter.setupColorFilter(filter: f)
        }
        
        if let filteredImageData = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage {
            if  let filteredImageRef = FilterImageManager.sharedInstance.ciContextFast.createCGImage(filteredImageData, from: filteredImageData.extent) {
                return UIImage(cgImage: filteredImageRef)
            }
        }
        
        return nil
    }
    
}
