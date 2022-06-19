//
//  ColorRoundButton.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class ColorRoundButton: UIView {

    private var frameWidth: CGFloat = 2.0

    @IBOutlet weak var circle: RoundImage!
    @IBOutlet weak var frameView: RoundImage!

    var isSelected: Bool = false {
        didSet {
            frameView.isHidden = !isSelected
        }
    }

    var color: UIColor = UIColor.clear {
        didSet {
            circle.backgroundColor = color
            frameView.setupAsFrame(color: color, width: frameWidth)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initContent()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initContent()
    }

    private  func initContent() {

        let view = loadViewFromNib()

        view.frame = bounds

        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        addSubview(view)
    }

    private func loadViewFromNib() -> UIView {

        let bundle = Bundle(for: ColorRoundButton.self)
        let nib = UINib(nibName: "ColorRoundButton", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView

        return view
    }

}
