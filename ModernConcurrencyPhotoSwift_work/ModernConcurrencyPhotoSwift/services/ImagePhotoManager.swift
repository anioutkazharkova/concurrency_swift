//
//  ImagePhotoManager.swift
//  HSLImageProcessing
//
//  Created by 1 on 08.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ImagePhotoManager: NSObject,PhotoHolderProtocol {
    
    var assets: PHFetchResult<AnyObject>?
    static let shared = ImagePhotoManager()
    var currentAsset: PHAsset?
    
    func saveImage(image: UIImage, successful:  @escaping() -> Void,
                   failure: @escaping() -> Void) {
        let size = CGSize(width: (currentAsset?.pixelWidth ?? 0).pxToDp(), height: (currentAsset?.pixelHeight ?? 0).pxToDp())
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image.resize(targetSize: size))
        }, completionHandler: { [weak self] success, error in
            if success {
                self?.currentAsset = nil
                successful()
            } else if error != nil {
                failure()
            } else {
                failure()
            }
        })
    }
    
    func loadAssets(success:@escaping (PHFetchResult<AnyObject>) -> Void,
                    failure: @escaping () -> Void) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            self.loadAssets(success: success)
        } else {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                if status == .authorized {
                    self.loadAssets(success: success)
                } else {
                    failure()
                }
            })
        }
    }
    
    func loadAssets(success:@escaping (PHFetchResult<AnyObject>) -> Void) {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 25000
        assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions) as? PHFetchResult<AnyObject>
        success(assets!)
    }
    
    func selectAsset(index: Int) {
        self.currentAsset = assets?[index] as? PHAsset
    }
    
    func loadImageForCurrentAsset(success: @escaping(UIImage) -> Void) {
        let width = UIScreen.main.bounds.width
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        if let item = currentAsset {
            
            PHImageManager.default().requestImage(for: item, targetSize: CGSize(width: width, height: 0.75 * width), contentMode: .aspectFill, options: options) {(image: UIImage?, info: [AnyHashable: Any]?) -> Void in
                if let _image = image {
                    success(_image)
                }
            }
        }
    }
    
    func loadImageForAsset(index: Int, size: CGFloat,success: @escaping(UIImage) -> Void) {
        if let item = assets?[index] as? PHAsset {
            PHImageManager.default().requestImage(for: item, targetSize: CGSize(width: size, height: size), contentMode: .aspectFill, options: nil) { (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
                if let _image = image {
                    success(_image)
                }
            }
        }
    }
}

protocol PhotoHolderProtocol : class {
    var assets: PHFetchResult<AnyObject>? {get set}
    func loadImageForAsset(index: Int, size: CGFloat,success: @escaping(UIImage) -> Void)
}
