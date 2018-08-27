//
//  TextField.swift
//  ControlledComponents
//
//  Created by Devin Abbott on 8/27/18.
//  Copyright © 2018 BitDisco, Inc. All rights reserved.
//

import AppKit
import Foundation

// MARK: - TextField

public class TextField: NSTextField, NSControlTextEditingDelegate {

    private struct InternalState {
        var textValue: String
        var selectedRange: NSRange
    }

    // MARK: Lifecycle

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        setUpSelectionObserver()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        setUpSelectionObserver()
    }

    // MARK: Public

    public var onChangeText: ((String) -> Void)?

    public var textValue: String = "" {
        didSet {
            textDidChangeInCallback = true
            previousState.textValue = textValue

            if oldValue == textValue { return }

            stringValue = textValue
        }
    }

    // MARK: Private

    private var textDidChangeInCallback = false

    private var currentState: InternalState {
        get {
            return InternalState(textValue: stringValue, selectedRange: selectedRange)
        }
        set {
            selectedRange = newValue.selectedRange
            stringValue = newValue.textValue
        }
    }

    // The text and selection values prior to a change
    private var previousState = InternalState(textValue: "", selectedRange: NSRange(location: 0, length: 0))

    private var selectedRange: NSRange {
        get { return currentEditor()?.selectedRange ?? NSRange(location: 0, length: 0) }
        set { currentEditor()?.selectedRange = newValue }
    }

    private func setUpSelectionObserver() {
        NotificationCenter.default.addObserver(
            forName: NSTextView.didChangeSelectionNotification,
            object: self,
            queue: nil,
            using: { notification in
                guard let object = notification.object,
                    (object as? NSTextView) === self.currentEditor(),
                    self.stringValue == self.previousState.textValue
                    else { return }
                self.previousState.selectedRange = self.currentState.selectedRange
        })
    }
}

// MARK: - NSTextFieldDelegate

extension TextField: NSTextFieldDelegate {
    override public func textDidChange(_ notification: Notification) {

        // Take a snapshot, since we want to make sure these values don't change by the time we re-assign them back
        let snapshotState = previousState

        onChangeText?(stringValue)

        if !textDidChangeInCallback {

            // Undo the user's changes
            previousState = snapshotState
            currentState = snapshotState
        }

        textDidChangeInCallback = false
    }
}
