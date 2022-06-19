//
//  FilterChangedListener.swift
//  HSLImageProcessing
//
//  Created by Admin on 08.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation

protocol FilterChangedListener: class {
    func filterItemChanged(index: Int)
    func filterColorSelected(color: Colors)
    func needSetupFilter()
}
