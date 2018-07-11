//
//  ControlledCheckbox.swift
//  SwiftPrimitiveComponents
//
//  Created by Devin Abbott on 7/11/18.
//  Copyright © 2018 devin_abbott. All rights reserved.
//

import Foundation
import AppKit

class ControlledCheckbox: NSButton {

    var onChange: ((Bool) -> Void)?

    var value: Bool {
        get { return state == .on }
        set { state = newValue ? .on : .off }
    }

    @objc func handleChange() {
        let newValue = value

        // Revert the value to before it was toggled
        value = !value

        // This view's owner should update the `value` if needed
        onChange?(newValue)
    }

    func setup() {
        setButtonType(.switch)
        action = #selector(handleChange)
        target = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
}
