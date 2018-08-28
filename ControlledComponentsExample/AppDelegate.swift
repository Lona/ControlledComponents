//
//  AppDelegate.swift
//  ControlledComponentsExample
//
//  Created by Devin Abbott on 8/27/18.
//  Copyright © 2018 BitDisco, Inc. All rights reserved.
//

import Cocoa
import ControlledComponents

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let contentView = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 200))

    let textInput = TextInput()
    let button = Button()
    let checkbox = Checkbox()

    var lockInput = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setUpViews()
        setUpConstraints()

        window.contentView = contentView
    }

    func setUpViews() {
        button.titleText = "Set to 'foo'"
        checkbox.titleText = "Lock input when the text is 'hello'"

        contentView.addSubview(button)
        contentView.addSubview(textInput)
        contentView.addSubview(checkbox)

        textInput.onChangeTextValue = { value in
            if self.lockInput && self.textInput.textValue == "hello" { return }

            Swift.print("Value changed", value)

            self.textInput.textValue = value
        }

        button.onPress = {
            self.textInput.textValue = "foo"
        }

        checkbox.onChangeValue = { value in
            self.checkbox.value = value
            self.lockInput = value
        }
    }

    func setUpConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        textInput.translatesAutoresizingMaskIntoConstraints = false
        checkbox.translatesAutoresizingMaskIntoConstraints = false

        button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true

        button.trailingAnchor.constraint(equalTo: textInput.leadingAnchor, constant: -10).isActive = true

        textInput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        textInput.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        textInput.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true

        checkbox.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10).isActive = true

        checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        checkbox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        checkbox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

