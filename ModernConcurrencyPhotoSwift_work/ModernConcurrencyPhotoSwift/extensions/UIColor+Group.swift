//
//  UIColor+Group.swift
//  HSLImageProcessing
//
//  Created by Admin on 08.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import  UIKit

extension UIColor {
    var colorGroup: Colors {
        get {
            let hue = self.hue()
            return hue.colorForHue()
        }
    }
}
