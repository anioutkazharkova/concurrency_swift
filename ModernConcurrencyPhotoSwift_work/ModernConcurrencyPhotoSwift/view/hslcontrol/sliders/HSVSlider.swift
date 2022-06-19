//
//  HSVSlider.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class HSVSlider: UISlider {
    
    private let gradient: CAGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       initContent()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       initContent()
    }
    
    private func initContent() {
        addGradient()
        self.setThumbImage(UIImage(), for: .normal)
        self.layer.cornerRadius = 0.0
    }

    func addGradient() {
        let colors = [ColorUtility.magenta.cgColor,
            ColorUtility.red.cgColor,
                     ColorUtility.orange.cgColor,
                     ColorUtility.yellow.cgColor,
                     ColorUtility.green.cgColor,
                     ColorUtility.aqua.cgColor,
                     ColorUtility.blue.cgColor,
                     ColorUtility.purple.cgColor
                     ]
        let trackImage = UIImage.gradientImage(size: self.bounds.size, colorSet: colors)
        self.setMinimumTrackImage(trackImage, for: .normal)
        self.setMaximumTrackImage(trackImage, for: .normal)
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = self.bounds.height
        return newBounds
    }
}
