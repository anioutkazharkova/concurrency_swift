//
//  ThumbSlider.swift
//  HSLImageProcessing
//
//  Created by Admin on 08.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class ThumbSlider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createThumb()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createThumb()
    }
    
    func createThumb() {
        let layerFrame = CGRect(x: 0, y: 0, width: 5.0, height: 15.0)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = CGPath(rect: layerFrame, transform: nil)
        shapeLayer.fillColor = UIColor.white.cgColor
        
        let thumb = CALayer.init()
        thumb.frame = layerFrame
        thumb.addSublayer(shapeLayer)
        
        UIGraphicsBeginImageContextWithOptions(thumb.frame.size, false, 0.0)
        
        thumb.render(in: UIGraphicsGetCurrentContext()!)
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setThumbImage(thumbImage, for: .normal)
        self.setThumbImage(thumbImage, for: .highlighted)
    }
}
