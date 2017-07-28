//
//  ViewController.swift
//  AdjustableTextField
//
//  Created by Peter Steele on 7/26/17.
//  Copyright © 2017 peteyP. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, AdjustableTextFieldDelegate {
    @IBOutlet weak var delegateValueLabel: NSTextField!
    @IBOutlet weak var delegateAdjustableTextField: AdjustableTextField!

    @IBOutlet weak var closureAdjustableTextField: AdjustableTextField!
    @IBOutlet weak var closureValueLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closureAdjustableTextField.onValueChangedHandler = { [unowned self] newVal in
            self.closureValueLabel.stringValue = "\(newVal)"
        }
        closureAdjustableTextField.value = 50
        closureAdjustableTextField.minValue = -100
        closureAdjustableTextField.maxValue = 100

        delegateAdjustableTextField.adjustableTextFieldDelegate = self
        delegateAdjustableTextField.value = 50
        delegateAdjustableTextField.minValue = -100
        delegateAdjustableTextField.maxValue = 100
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func onValueChanged(_ newValue: Double) {
        delegateValueLabel.stringValue = "\(newValue)"
    }

}
