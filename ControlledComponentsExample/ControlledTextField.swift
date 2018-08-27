//
//  ControlledTextField.swift
//  SwiftPrimitiveComponents
//
//  Created by devin_abbott on 5/29/18.
//  Copyright © 2018 devin_abbott. All rights reserved.
//

import AppKit
import Foundation

// MARK: - String

private extension String {
  func clamp(index targetIndex: Int) -> Int {
    return min(max(targetIndex, 0), count)
  }

  func slice(start: Int, end: Int? = nil) -> String {
    let startIndex = self.index(self.startIndex, offsetBy: clamp(index: start))
    let endIndex = self.index(self.startIndex, offsetBy: clamp(index: end ?? count))

    return String(self[startIndex..<endIndex])
  }
}

// MARK: - ControlledTextField

class ControlledTextField: NSTextField, NSControlTextEditingDelegate {

  private struct InternalState {
    var textValue: String
    var selectedRange: NSRange
  }

  // MARK: - Lifecycle

  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)

    setUpSelectionObserver()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    setUpSelectionObserver()
  }

  // MARK: - Public

  var onChangeText: ((String) -> Void)?

  var textValue: String = "" {
    didSet {
      textDidChangeInCallback = true
      previousState.textValue = textValue

      if oldValue == textValue { return }

      stringValue = textValue
    }
  }

  // MARK: - Private

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

extension ControlledTextField: NSTextFieldDelegate {
  override func textDidChange(_ notification: Notification) {

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
