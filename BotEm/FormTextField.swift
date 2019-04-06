//
//  FormTextField.swift
//  BotEm
//
//  Created by Julien Calfayan on 4/5/19.
//  Copyright © 2019 Xvent Inc. All rights reserved.
//

import UIKit

@IBDesignable
class FormTextField: UITextField {

    @IBInspectable var inset: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

}
