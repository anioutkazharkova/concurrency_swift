//
//  UIImage+Gradient.swift
//  HSLImageProcessing
//
//  Created by Admin on 08.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static  func gradientImage(size: CGSize, colorSet: [CGColor]) -> UIImage? {
        let tgl = UIView.createGradient(size: size, colorSet: colorSet)
        
        UIGraphicsBeginImageContextWithOptions(size, tgl.isOpaque, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        tgl.render(in: context)
        let image =
            
            UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets:
                UIEdgeInsets.init(top: 0, left: size.height, bottom: 0, right: size.height))
        UIGraphicsEndImageContext()
        return image
    }
}
