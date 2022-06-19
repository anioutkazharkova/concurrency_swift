//
//  RoundImage.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundImage: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = self.bounds.width/2
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0
    }
}

extension RoundImage {
    func setupAsFrame(color: UIColor, width: CGFloat) {
        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
