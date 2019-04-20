//
//  ChangePasswordViewController.swift
//  BotEm
//
//  Created by Julien Calfayan on 4/13/19.
//  Copyright © 2019 Xvent Inc. All rights reserved.
//

import UIKit
import Parse

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var currentPasswordField: FormTextField!
    @IBOutlet weak var newPasswordField: FormTextField!
    @IBOutlet weak var repeatNewPasswordField: FormTextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let borderPurple = UIColor(hexFromString: "#8925B1")
    let borderDarkPurple = UIColor(hexFromString: "#362B57")
    let borderRed = UIColor(hexFromString: "#D31F49")
    
    let user = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentPasswordField.layer.cornerRadius = 10
        currentPasswordField.layer.borderWidth = 1
        currentPasswordField.layer.borderColor = borderDarkPurple.cgColor
        
        newPasswordField.layer.cornerRadius = 10
        newPasswordField.layer.borderWidth = 1
        newPasswordField.layer.borderColor = borderDarkPurple.cgColor
        
        repeatNewPasswordField.layer.cornerRadius = 10
        repeatNewPasswordField.layer.borderWidth = 1
        repeatNewPasswordField.layer.borderColor = borderDarkPurple.cgColor
        
        changePasswordButton.layer.cornerRadius = 10
        changePasswordButton.layer.borderWidth = 2
        changePasswordButton.layer.borderColor = borderPurple.cgColor
        
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = borderRed.cgColor
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onChangePass(_ sender: Any) {
        let currentPassword = user!["stringPass"] as! String
        
        if (currentPasswordField.text != currentPassword) {
            print("Current Password Incorrect")
        } else if (newPasswordField.text != repeatNewPasswordField.text) {
            print("Passwords Do Not Match")
        } else {
            user?.password = newPasswordField.text
            user!["stringPass"] = newPasswordField.text
            user?.saveInBackground() { (success, error) in
                if success {
                    print("Password Changed")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
}
