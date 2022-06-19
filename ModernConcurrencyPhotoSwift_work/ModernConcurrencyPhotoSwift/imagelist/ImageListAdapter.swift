//
//  ImageAdapter.swift
//  ModernConcurrencyPhotoSwift
//
//  Created by Anna Zharkova on 13.06.2022.
//

import Foundation
import UIKit

class ImageListAdapter : NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var sideSize: CGFloat = 180.0
    weak var owner: ListOwner?
    var images: [UIImage] = [UIImage]()
    
    func setupImages(images: [UIImage]) {
        self.images = [UIImage]()
        self.images.append(contentsOf: images)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCell.cellIdentifier,
                                                            for: indexPath) as? ImagePickerCell else {
                                                                return UICollectionViewCell()
        }
        
        cell.image = images[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sideSize, height: sideSize)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        owner?.selectedItem(index: indexPath.row)
    }
}
