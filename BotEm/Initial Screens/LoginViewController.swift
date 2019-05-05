//
//  LoginViewController.swift
//  BotEm
//
//  Created by Julien Calfayan on 4/5/19.
//  Copyright © 2019 Xvent Inc. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: FormTextField!
    @IBOutlet weak var passwordField: FormTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    let borderPurple = UIColor(hex: "#8925B1ff")
    let borderDarkPurple = UIColor(hex: "#362B57ff")
    let borderGray = UIColor(hex: "#A9A9A9ff")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameField.layer.cornerRadius = 10
        usernameField.layer.borderWidth = 1
        usernameField.layer.borderColor = borderDarkPurple?.cgColor
        
        passwordField.layer.cornerRadius = 10
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = borderDarkPurple?.cgColor
        
        signInButton.layer.cornerRadius = 10
        signInButton.layer.borderWidth = 2
        signInButton.layer.borderColor = borderPurple?.cgColor
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.borderColor = borderGray?.cgColor
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text!.uppercased()
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password)
        { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                self.incorrectLoginAlert()
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @IBAction func endEditingTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc func incorrectLoginAlert() {
        let alert = UIAlertController(title: "Login Incorrect", message: "Username and/or Password Incorrect. \n Please Try Again.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Sounds Good", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
}

extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
