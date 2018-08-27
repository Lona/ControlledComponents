//
//  Checkbox.swift
//  ControlledComponents
//
//  Created by Devin Abbott on 8/27/18.
//  Copyright © 2018 BitDisco, Inc. All rights reserved.
//

import AppKit
import Foundation

// MARK: - Checkbox

public class Checkbox: NSButton {

    // MARK: Lifecycle

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    // MARK: Public

    public var onChangeValue: ((Bool) -> Void)?

    public var value: Bool {
        get { return state == .on }
        set { state = newValue ? .on : .off }
    }

    // MARK: Private

    private func setup() {
        setButtonType(.switch)
        action = #selector(handleChange)
        target = self
    }

    @objc private func handleChange() {
        let newValue = value

        // Revert the value to before it was toggled
        value = !value

        // This view's owner should update the `value` if needed
        onChangeValue?(newValue)
    }
}
