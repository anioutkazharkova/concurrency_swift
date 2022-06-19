//
//  ImageHorizontalCollection.swift
//  iOSFilterApp
//
//  Created by Anna Zharkova on 18.05.2022.
//

import Foundation
import UIKit
class ImageHorizontallAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var owner: ListOwner? = nil
    var sideSize: CGFloat = 130.0
    var images: [UIImage] = [UIImage]()
    
    func setupItems(items: [UIImage]) {
        self.images = [UIImage]()
        self.images.append(contentsOf: items)
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        owner?.selectedItem(index: indexPath.row)
    }
}
