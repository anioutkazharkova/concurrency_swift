//
//  GradientSlider.swift
//  HSLImageProcessing
//
//  Created by 1 on 06.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit

class GradientSlider: ThumbSlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private let gradient: CAGradientLayer = CAGradientLayer()
    
    func addGradient(colors: [CGColor]) {
        
        let trackImage = UIImage.gradientImage(size: CGSize(width: self.bounds.width, height: 2), colorSet: colors)
        self.setMinimumTrackImage(trackImage, for: .normal)
        self.setMaximumTrackImage(trackImage, for: .normal)
        
    }
}
