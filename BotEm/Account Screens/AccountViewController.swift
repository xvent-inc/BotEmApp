//
//  AccountViewController.swift
//  BotEm
//
//  Created by Julien Calfayan on 4/13/19.
//  Copyright © 2019 Xvent Inc. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var firstLastLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var changePassButton: UIButton!
    
    let user = PFUser.current()

    let borderPurple = UIColor(hexFromString: "#8925B1")
    let borderTeal = UIColor(hexFromString: "#3AC2A0")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let username = user?.username
        usernameLabel.text = "@" + username!
        
        let imageFile = user?["profilePicture"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        profilePictureView.layer.cornerRadius = 100
        profilePictureView.clipsToBounds = true
        profilePictureView.layer.borderWidth = 4
        profilePictureView.layer.borderColor = borderTeal.cgColor
        profilePictureView.af_setImage(withURL: url)
        
        let firstName = user?["firstName"] as! String
        let lastName = user?["lastName"] as! String
        firstLastLabel.text = firstName + " " + lastName
        
        changePassButton.layer.cornerRadius = 10
        changePassButton.layer.borderWidth = 2
        changePassButton.layer.borderColor = borderPurple.cgColor
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
    
    @IBAction func onProfilePic(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            
            picker.sourceType = UIImagePickerController.SourceType.camera
            self.present(picker, animated: true, completion: nil)
        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 200, height: 200)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        profilePictureView.image = scaledImage
        
        let imageData = profilePictureView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        user?["profilePicture"] = file
        
        user?.saveInBackground() { (success, error) in
            if success {
                print("Profile Picture Saved!")
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
