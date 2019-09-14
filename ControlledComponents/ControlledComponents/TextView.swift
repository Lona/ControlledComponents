//
//  TextView.swift
//  ControlledComponents
//
//  Created by Devin Abbott on 9/14/19.
//  Copyright © 2019 BitDisco, Inc. All rights reserved.
//

import AppKit
import Foundation

// MARK: - TextInput

open class TextView: NSTextView {

    fileprivate struct InternalState {
        var textValue: String
        var selectedRange: NSRange
    }

    // MARK: Lifecycle

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)

        setUp()
    }

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        setUp()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        setUp()
    }

    private func setUp() {
        delegate = self
        setUpSelectionObserver()
    }

    // MARK: Public

    public var onChangeTextValue: ((String) -> Void)?
    public var onSubmit: (() -> Void)?
    public var onPressEscape: (() -> Void)?

    public var textValue: String = "" {
        didSet {
            textDidChangeInCallback = true

            previousState.textValue = textValue
            if currentState.textValue != textValue {
                currentState.textValue = textValue
            }
        }
    }

    // MARK: Private

    private var textDidChangeInCallback = false

    private var currentState: InternalState {
        get {
            return InternalState(textValue: string, selectedRange: selectedRange)
        }
        set {
            selectedRange = newValue.selectedRange
            string = newValue.textValue
        }
    }

    // The text and selection values prior to a change
    fileprivate var previousState = InternalState(textValue: "", selectedRange: NSRange(location: 0, length: 0))

    private func setUpSelectionObserver() {
        NotificationCenter.default.addObserver(
            forName: NSTextView.didChangeSelectionNotification,
            object: self,
            queue: nil,
            using: { notification in
                guard let object = notification.object,
                    (object as? NSTextView) === self,
                    self.string == self.previousState.textValue
                    else { return }
                self.previousState.selectedRange = self.currentState.selectedRange
        })
    }
}

// MARK: - NSTextViewDelegate

extension TextView: NSTextViewDelegate {
    open override func didChangeText() {
        // Take a snapshot, since we want to make sure these values don't change by the time we re-assign them back
        let snapshotState = previousState

        textDidChangeInCallback = false

        onChangeTextValue?(string)

        if !textDidChangeInCallback {

            // Undo the user's changes
            previousState = snapshotState
            currentState = snapshotState
        }

        textDidChangeInCallback = false
    }

    open override func doCommand(by selector: Selector) {
        if selector == #selector(NSResponder.insertNewline(_:)) {
            onSubmit?()
            return
        } else if selector == #selector(NSResponder.cancelOperation(_:)) {
            onPressEscape?()
            return
        }

        return super.doCommand(by: selector)
    }
}
