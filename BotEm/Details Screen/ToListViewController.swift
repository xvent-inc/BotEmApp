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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        botName.text = bot["BotName"] as? String
        
        listBotImage.layer.cornerRadius = 100
        listBotImage.layer.borderWidth = 2
        listBotImage.layer.borderColor = imageBorder.cgColor
        
        priceField.layer.cornerRadius = 10
        priceField.layer.borderWidth = 1
        priceField.layer.borderColor = borderDarkPurple?.cgColor
        
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
        let transactionFeeAmount = sellPrice! * 0.095
        let paymentProcFeeAmount = sellPrice! * 0.03
        
        let payoutNumber: Double = (sellPrice! - transactionFeeAmount - paymentProcFeeAmount)
        
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
}
