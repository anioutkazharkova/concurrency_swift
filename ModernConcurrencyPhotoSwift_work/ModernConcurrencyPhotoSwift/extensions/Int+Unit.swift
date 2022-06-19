//
//  Int+Unit.swift
//  HSLImageProcessing
//
//  Created by Admin on 08.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    func pxToDp() -> CGFloat {
        return CGFloat(self)/UIScreen.main.scale
    }
    func dpToPx() -> CGFloat {
        return CGFloat(self)*UIScreen.main.scale
    }
}
