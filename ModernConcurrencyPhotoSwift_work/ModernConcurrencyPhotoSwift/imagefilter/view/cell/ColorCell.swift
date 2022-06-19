//
//  ColorCell.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    static let cellIdentifier = "ColorCell"
    @IBOutlet weak var colorButton: ColorRoundButton!

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    func setupData(colorItem: ColorItem) {
        self.colorButton.isSelected = colorItem.isSelected
        self.colorButton?.color = colorItem.color.getColor()
    }

}
