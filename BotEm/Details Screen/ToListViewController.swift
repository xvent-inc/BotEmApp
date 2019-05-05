//
//  ToListViewController.swift
//  BotEm
//
//  Created by Rodolfo jr Punzalan on 4/17/19.
//  Copyright © 2019 Xvent Inc. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ToListViewController: UIViewController {
    
    
    @IBOutlet weak var listBotImage: UIImageView!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var listNowButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var botName: UILabel!
    @IBOutlet weak var transactionFee: UILabel!
    @IBOutlet weak var paymentProcFee: UILabel!
    @IBOutlet weak var payoutAmount: UILabel!
    
    let borderDarkPurple = UIColor(hex: "#362B57ff")
    let borderRed = UIColor(hex: "#D31F49ff")
    var imageBorder: UIColor!
    var botType: String!
    var bot: PFObject!
    
    var payoutNumber: Double = 0.0
    var transactionFeeAmount: Double = 0.0
    var paymentProcFeeAmount: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        botName.text = bot["BotName"] as? String
        
        listBotImage.layer.cornerRadius = 100
        listBotImage.layer.borderWidth = 2
        listBotImage.layer.borderColor = imageBorder.cgColor
        
        priceField.layer.cornerRadius = 10
        priceField.layer.borderWidth = 1
        priceField.layer.borderColor = borderDarkPurple?.cgColor
        
        priceField.becomeFirstResponder()
        
        listNowButton.layer.cornerRadius = 10
        
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = borderRed?.cgColor
        
        let imageFile = bot["BotImage"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        listBotImage.af_setImage(withURL: url)
    }

    @IBAction func sellPriceChanged(_ sender: Any) {
        let sellPrice = priceField.text._bridgeToObjectiveC().doubleValue
        transactionFeeAmount = sellPrice! * 0.095
        paymentProcFeeAmount = sellPrice! * 0.03
        
        payoutNumber = (sellPrice! - transactionFeeAmount - paymentProcFeeAmount)
        
        transactionFee.text = String(format: "$%.2f", transactionFeeAmount)
        paymentProcFee.text = String(format: "$%.2f", paymentProcFeeAmount)
        payoutAmount.text = String(format: "$%.2f", payoutNumber)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func onList(_ sender: Any) {
        let listing = PFObject(className: "Listings")
        
        listing["seller"] = PFUser.current()!
        listing["sellerEmail"] = PFUser.current()?.email
        listing["botName"] = bot["BotName"] as? String
        listing["botType"] = botType.uppercased()
        listing["transactionAmount"] = priceField.text
        listing["transactionType"] = "SALE"
        listing["payoutAmount"] = String(format: "%.2f", payoutNumber)
        listing["paymentProcFee"] = String(format: "%.2f", paymentProcFeeAmount)
        listing["transactionFee"] = String(format: "%.2f", transactionFeeAmount)
        
        listing.saveInBackground() { (success, error) in
            if success {
                self.botListedAlert()
                print("Listing Posted!")
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @objc func botListedAlert() {
        let alert = UIAlertController(title: "Bot Listed!", message: "Thank you for listing your bot! You can view or delete your listing in the Transactions Tab of the App.", preferredStyle: .alert)
    
        alert.addAction(UIAlertAction(title: "Thank You!", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "listNowSegue", sender: nil)
        }))
        
        self.present(alert, animated: true)
    }
}
