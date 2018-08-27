//
//  AppDelegate.swift
//  SwiftPrimitiveComponents
//
//  Created by devin_abbott on 4/21/18.
//  Copyright © 2018 devin_abbott. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!

  @objc func handleButtonPress(_ sender: AnyObject) {
    textInput.textValue = "foo"
  }

  let textInput = ControlledTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 200))


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application

    let view = NSBox(frame: NSRect(x: 0, y: 0, width: 200, height: 200))

    view.fillColor = .white
    view.boxType = .custom
    view.borderType = .noBorder
    view.contentViewMargins = .zero

    textInput.textValue = "ok"
    textInput.onChangeText = { value in
      if self.textInput.textValue == "hello" { return }
      Swift.print("Value changed", value)
      self.textInput.textValue = value
    }


//    let textInput = ControlledTextView(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
//    textInput.onChangeText = { value in
//      Swift.print("Value changed", value)
//      textInput.string = value
//    }

    let button = NSButton(title: "Test", target: self, action: #selector(handleButtonPress(_:)))
    view.addSubview(button)
    button.frame = NSRect(x: 0, y: 200, width: 60, height: 26)

    view.addSubview(textInput)

    let checkbox = ControlledCheckbox(frame: NSRect.init(x: 0, y: 250, width: 50, height: 50))
    checkbox.onChange = { value in
        checkbox.value = value
    }
    view.addSubview(checkbox)

    // Present the view in Playground
    window.contentView = view
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

