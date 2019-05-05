//
//  SignUpViewController.swift
//  BotEm
//
//  Created by Julien Calfayan on 4/5/19.
//  Copyright © 2019 Xvent Inc. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameField: FormTextField!
    @IBOutlet weak var lastNameField: FormTextField!
    @IBOutlet weak var usernameField: FormTextField!
    @IBOutlet weak var emailAddressField: FormTextField!
    @IBOutlet weak var passwordField: FormTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let borderPurple = UIColor(hex: "#8925B1ff")
    let borderDarkPurple = UIColor(hex: "#362B57ff")
    let borderRed = UIColor(hex: "#D31F49ff")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        firstNameField.layer.cornerRadius = 10
        firstNameField.layer.borderWidth = 1
        firstNameField.layer.borderColor = borderDarkPurple?.cgColor
        
        lastNameField.layer.cornerRadius = 10
        lastNameField.layer.borderWidth = 1
        lastNameField.layer.borderColor = borderDarkPurple?.cgColor
        
        usernameField.layer.cornerRadius = 10
        usernameField.layer.borderWidth = 1
        usernameField.layer.borderColor = borderDarkPurple?.cgColor
        
        emailAddressField.layer.cornerRadius = 10
        emailAddressField.layer.borderWidth = 1
        emailAddressField.layer.borderColor = borderDarkPurple?.cgColor
        
        passwordField.layer.cornerRadius = 10
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = borderDarkPurple?.cgColor
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.borderColor = borderPurple?.cgColor
        
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = borderRed?.cgColor
    }
    
    @IBAction func onSignUpButton(_ sender: Any) {
        let user = PFUser()
        
        let tempUsername = usernameField.text?.uppercased()
        let tempEmail = emailAddressField.text?.uppercased()
        let tempFirstName = firstNameField.text?.uppercased()
        let tempLastName = lastNameField.text?.uppercased()
        
        user.username = tempUsername
        user.password = passwordField.text
        user.email = tempEmail
        
        user["firstName"] = tempFirstName
        user["lastName"] = tempLastName
        user["stringPass"] = passwordField.text
        
        let imageData = UIImage(named: "noProfilePicture")!.pngData()
        let file = PFFileObject(data: imageData!)
        
        user["profilePicture"] = file
        
        user.signUpInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.missingInformationAlert()
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func endEditingTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc func missingInformationAlert() {
        let alert = UIAlertController(title: "Missing Information", message: "Information is missing or incorrect. \n Please Try Again.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Sounds Good", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

