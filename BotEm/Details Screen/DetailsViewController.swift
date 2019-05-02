//
//  DetailsViewController.swift
//  BotEm
//
//  Created by Rodolfo jr Punzalan on 4/16/19.
//  Copyright © 2019 Xvent Inc. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var botImage: UIImageView!
    @IBOutlet weak var botName: UILabel!
    @IBOutlet weak var botDescription: UILabel!
    @IBOutlet weak var botPrice: UILabel!
    @IBOutlet weak var lowestPrice: UILabel!
    @IBOutlet weak var listNowButton: UIButton!
    @IBOutlet weak var purchaseButton: UIButton!
    
    var bot: PFObject!
    var botType: String!
    var imageBorder: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listNowButton.layer.cornerRadius = 10
        purchaseButton.layer.cornerRadius = 10
        
        botImage.layer.cornerRadius = 100
        botImage.layer.borderWidth = 2
        botImage.layer.borderColor = imageBorder.cgColor
        
        let imageFile = bot["BotImage"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        botImage.af_setImage(withURL: url)
        
        botName.text = bot["BotName"] as? String
        botDescription.text = bot["BotDescription"] as? String
        botPrice.text = "$\(bot["LastSoldPrice"]!)"
        lowestPrice.text = "$\(bot["CurrentPrice"]!)"
    }
    // note to test commit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toListViewController = segue.destination as! ToListViewController
        
        toListViewController.bot = bot
        toListViewController.botType = botType
        
        if (botType == "Lifetime") {
            toListViewController.imageBorder = UIColor(hex: "#3AC2A0ff")
        } else {
            toListViewController.imageBorder = UIColor(hex: "#FDCF70ff")
        }
    }
}

