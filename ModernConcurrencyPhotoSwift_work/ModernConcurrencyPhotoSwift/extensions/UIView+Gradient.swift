//
//  UIView+Gradient.swift
//  HSLImageProcessing
//
//  Created by Admin on 08.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    static func createGradient(size: CGSize, colorSet: [CGColor]) -> CAGradientLayer {
        let tgl = CAGradientLayer()
        tgl.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        tgl.cornerRadius = 0.0
        tgl.masksToBounds = false
        tgl.colors = colorSet
        tgl.startPoint = CGPoint.init(x: 0.0, y: 0)
        tgl.endPoint = CGPoint.init(x: 1, y: 0)
        return tgl
    }
}
