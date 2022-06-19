//
//  ColorFilter.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import  UIKit

//Модель фильтра
class ColorFilter {

    static let maxHue: CGFloat = 360.0
    static let step: CGFloat = 15/360.0
    static let lumDiv: CGFloat = 100.0
    static let lumStart: CGFloat = 50.0
    static let lumMin: CGFloat = 20.0
    static let lumMax: CGFloat = 80.0

    var defaultColor: Colors
    var selectedHue: CGFloat = CGFloat(0)
    var selectedSat: CGFloat = CGFloat(1)
    var selectedLum: CGFloat = CGFloat(ColorFilter.lumStart)
    var sense = CGFloat(0.15)

    var shift: CIVector {
        get {
            return CIVector(x: (selectedHue/ColorFilter.maxHue)*sense, y: selectedSat,
                            z: normalizeLum)
        }
    }

    //Преобразование светлоты для использования в фильтре
    var normalizeLum: CGFloat {
        if (selectedLum > ColorFilter.lumStart) {
          return  1.0 + (selectedLum - ColorFilter.lumStart)/(ColorFilter.lumDiv)*0.5*sense
        } else {
            return 1.0 - (ColorFilter.lumStart - selectedLum)/(ColorFilter.lumDiv)*0.5*sense
        }
    }

    init(color: Colors) {
        self.defaultColor = color
    }

}
