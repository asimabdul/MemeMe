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
            memeLabel.attributedText = formatMemeText(textField.text)
            memeLabel.minimumScaleFactor = 0.6
            memeLabel.adjustsFontSizeToFitWidth = true
        } else {
            memeLabel.text = ""
        }
        
        textField.hidden = true
        memeLabel.hidden = false
        return true
    }
    
    func formatMemeText(string: String) -> NSAttributedString {
        var strokeAttrs = [NSStrokeWidthAttributeName: -5,
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeColorAttributeName: UIColor.blackColor()
        ]
        
        strokeAttrs[NSFontAttributeName] = UIFont(name: "Impact", size: 40)
        
        var attributedText = NSAttributedString(string: string.uppercaseString, attributes: strokeAttrs)
        return attributedText
    }
    
}