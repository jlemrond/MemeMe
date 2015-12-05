//
//  textFieldDelegate.swift
//  MemeMe
//
//  Created by Jason Lemrond on 12/4/15.
//  Copyright © 2015 Jason Lemrond. All rights reserved.
//

import Foundation
import UIKit

class textFieldDelegate: NSObject, UITextFieldDelegate {
  
  // Delete text if text field still has the default text present
  func textFieldDidBeginEditing(textField: UITextField) {
    if textField.text == "TOP" || textField.text == "BOTTOM" {
      textField.text = ""
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}