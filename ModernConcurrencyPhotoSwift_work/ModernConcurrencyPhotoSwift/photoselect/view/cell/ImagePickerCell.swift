//
//  ImagePickerCell.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class ImagePickerCell: UICollectionViewCell {

    static let cellIdentifier = "ImagePickerCell"
    @IBOutlet weak  var imageView: UIImageView!

    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil 
    }

}
