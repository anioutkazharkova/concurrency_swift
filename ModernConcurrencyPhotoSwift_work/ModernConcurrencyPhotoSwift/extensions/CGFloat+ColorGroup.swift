//
//  CGFloat+ColorGroup.swift
//  HSLImageProcessing
//
//  Created by Admin on 08.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit

//По цвету получаем его группу для сдвига
extension CGFloat {
    func colorForHue() -> Colors {
        let step: CGFloat = ColorFilter.step
        let correctHue = self < 0 ? 1 + self : self
        switch(correctHue) {
        case Colors.magenta.hue+step..<1.0, Colors.red.hue..<Colors.orange.hue:
            return .red
        case Colors.orange.hue..<Colors.orange.hue+step/2:
            return .orange
        case Colors.yellow.hue-step/2..<Colors.green.hue-step:
            return .yellow
        case Colors.green.hue-step..<Colors.aqua.hue - step:
            return .green
        case Colors.aqua.hue-step..<Colors.blue.hue-step:
            return .aqua
        case Colors.blue.hue-step..<Colors.purple.hue-step/2:
            return .blue
        case Colors.purple.hue-step/2..<Colors.magenta.hue-step/2:
            return .purple
        case Colors.magenta.hue-step/2..<Colors.magenta.hue+step:
            return .magenta
        default:
            return .red
        }
    }
}
