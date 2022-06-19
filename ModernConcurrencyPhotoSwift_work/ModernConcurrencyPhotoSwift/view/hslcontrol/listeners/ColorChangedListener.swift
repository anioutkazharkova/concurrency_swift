//
//  ColorChangedListener.swift
//  HSLImageProcessing
//
//  Created by Admin on 08.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation

protocol ColorChangedListener: class {
    func colorChanged(filter: ColorFilter)
}
