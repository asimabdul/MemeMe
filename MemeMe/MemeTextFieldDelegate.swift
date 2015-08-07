//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Asim Abdul on 8/6/15.
//  Copyright (c) 2015 AsimAbdul. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var memeLabel: UILabel!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if !textField.text.isEmpty {
            memeLabel.text = textField.text
        }
        textField.hidden = true
        memeLabel.hidden = false
        return true
    }
    
}