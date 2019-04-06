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
    
    
    let borderPurple = UIColor(hexFromString: "#8925B1")
    let borderDarkPurple = UIColor(hexFromString: "#362B57")
    let borderGray = UIColor(hexFromString: "#A9A9A9")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameField.layer.cornerRadius = 10
        usernameField.layer.borderWidth = 1
        usernameField.layer.borderColor = borderDarkPurple.cgColor
        
        passwordField.layer.cornerRadius = 10
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = borderDarkPurple.cgColor
        
        signInButton.layer.cornerRadius = 10
        signInButton.layer.borderWidth = 2
        signInButton.layer.borderColor = borderPurple.cgColor
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.borderColor = borderGray.cgColor
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text!.uppercased()
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password)
        { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            
        }
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
