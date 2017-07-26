//
//  ViewController.swift
//  AdjustableTextField
//
//  Created by Peter Steele on 7/26/17.
//  Copyright © 2017 peteyP. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, AdjustableTextFieldDelegate {

    @IBOutlet weak var valueLabel: NSTextField!
    @IBOutlet weak var adjustableTextField: AdjustableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Closure style or Delegate style
        adjustableTextField.onValueChangedHandler = { [unowned self] newVal in
            self.valueLabel.stringValue = "\(newVal)"
        }
        
        adjustableTextField.adjustableTextFieldDelegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func onValueChanged(_ newValue: Int) {
        valueLabel.stringValue = "\(newValue)"
    }

}

