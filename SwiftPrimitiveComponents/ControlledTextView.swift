////
////  TextInput.swift
////  SwiftPrimitiveComponents
////
////  Created by devin_abbott on 4/21/18.
////  Copyright © 2018 devin_abbott. All rights reserved.
////
//
//import AppKit
//
//extension String {
//  func clamp(index targetIndex: Int) -> Int {
//    return min(max(targetIndex, 0), count)
//  }
//
//  func slice(start: Int, end: Int? = nil) -> String {
//    let startIndex = self.index(self.startIndex, offsetBy: clamp(index: start))
//    let endIndex = self.index(self.startIndex, offsetBy: clamp(index: end ?? count))
//
//    return String(self[startIndex..<endIndex])
//  }
//}
//
//class ControlledTextView: NSTextView,
//  NSTextFieldDelegate,
//  NSControlTextEditingDelegate
//{
//
//  // MARK: - Lifecycle
//
//  override init(frame frameRect: NSRect) {
//    super.init(frame: frameRect)
//    self.delegate = self
//  }
//
//  override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
//    super.init(frame: frameRect, textContainer: container)
//    self.delegate = self
//    allowsUndo = true
//  }
//
//  required init?(coder: NSCoder) {
//    super.init(coder: coder)
//  }
//
//  // MARK: - Public
//
//  var onChangeText: ((String) -> Void)?
//
//  override var string: String {
//    get {
//      return super.string
//    }
//    set {
//      let oldValue = string
//      let oldRange = selectedRange()
//
//      var index = newValue.count - oldValue.count + oldRange.upperBound
//
//      // Handle forward-deletion, e.g. Ctrl+K.
//      // The index may be negative at this point. If we detect that the string hasn't changed
//      // before the cursor, then we shouldn't move the cursor toward the start of the string.
//      if newValue.slice(start: 0, end: oldRange.lowerBound) ==
//        oldValue.slice(start: 0, end: oldRange.lowerBound) {
//        index = max(index, oldRange.lowerBound)
//      }
//
//      let updatedRange = NSRange(location: index, length: 0)
//
//      // Register undo
//
////      undoManager?.registerUndo(withTarget: self) { [weak self] view in
////        self?.onChangeText?(oldValue)
////      }
////      undoManager?.setActionName("Typing")
//
//      // Perform UI updates
//
//            locked = true
//
//      let fullRange = NSRange(location: 0, length: oldValue.count)
//      if shouldChangeText(in: fullRange, replacementString: newValue) {
////        replaceCharacters(in: fullRange, with: newValue)
//          textStorage?.beginEditing()
//          textStorage?.replaceCharacters(in: fullRange, with: newValue)
//          textStorage?.endEditing()
//          didChangeText()
//      }
////      insertText(newValue, replacementRange: fullRange)
//
//
////      super.string = newValue
//      locked = false
//      setSelectedRange(updatedRange)
//    }
//  }
//
//  // MARK: - Private
//
//  private var locked = false
//}
//
//extension ControlledTextView: NSTextViewDelegate {
//  func textView(
//    _ textView: NSTextView,
//    shouldChangeTextIn affectedCharRange: NSRange,
//    replacementString: String?) -> Bool {
//
//    if locked {
//      return false
//    }
//
//    if let replacementString = replacementString,
//      let range = Range(affectedCharRange, in: string) {
//      let updated = string.replacingCharacters(in: range, with: replacementString)
//
//      onChangeText?(updated)
//    }
//
//    return false
//  }
//}
