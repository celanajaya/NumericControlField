//
//  ViewController.swift
//  NumericControlField
//
//  Created by Peter Steele on 7/26/17.
//  Copyright © 2017 peteyP. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NumericControlFieldDelegate {
    
    @IBOutlet weak var delegateValueLabel: NSTextField!
    @IBOutlet weak var delegateNumericControlField: NumericControlField!

    @IBOutlet weak var closureNumericControlField: NumericControlField!
    @IBOutlet weak var closureValueLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        closureNumericControlField.valueChangedHandler = { [unowned self] newVal in
            self.closureValueLabel.stringValue = "\(newVal)"
        }
        closureNumericControlField.value = 50
        closureNumericControlField.minValue = -100
        closureNumericControlField.maxValue = 100

        delegateNumericControlField.numericControlFieldDelegate = self
        delegateNumericControlField.value = 50
        delegateNumericControlField.minValue = -100
        delegateNumericControlField.maxValue = 100
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func numericControlField(_ numericControlField: NumericControlField, didChangeValue newValue: Double) {
        delegateValueLabel.stringValue = "\(newValue)"
    }

}
