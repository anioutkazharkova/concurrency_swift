//
//  ActionImageButton.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

protocol LongPressListener: class {
    func longPressStarted()
    func longPressEnded()
}

class ActionImageButton: UIButton {
    weak var listener: LongPressListener?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initContent()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initContent()
    }

    override func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) {
        self.tintColor = UIColor.white
        super.setBackgroundImage(image?.withRenderingMode(.alwaysTemplate), for: state)
    }

    private  func initContent() {
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        listener?.longPressStarted()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        listener?.longPressEnded()
    }

}
