//
//  ColorItem.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation

class ColorItem {
    var isSelected: Bool = false
    var color: Colors = .red
    var colorFilter: ColorFilter

    init(color: Colors) {
        self.color = color
        self.colorFilter = ColorFilter(color: color)
    }

    init(filter: ColorFilter) {
        self.colorFilter = filter
        self.color = filter.defaultColor
    }
}
