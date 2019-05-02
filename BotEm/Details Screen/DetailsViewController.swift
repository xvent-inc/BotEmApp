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
    var listings = [PFObject]()
    var nameOfBot: String = " "
    var botTypeCopy: String = " "
    
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
        nameOfBot = (bot["BotName"] as? String)!
        botTypeCopy = botType.uppercased()
        
        botDescription.text = bot["BotDescription"] as? String
        //botPrice.text = "$\(bot["LastSoldPrice"]!)"
        //lowestPrice.text = "$\(bot["CurrentPrice"]!)"
        
        let listingsQuery = PFQuery(className: "Listings")
        listingsQuery.whereKey("botName", equalTo: nameOfBot)
        listingsQuery.whereKey("botType", equalTo: botTypeCopy)
        listingsQuery.order(byAscending: "transactionAmount")
        listingsQuery.selectKeys(["transactionAmount"])
        listingsQuery.limit = 1
        
        listingsQuery.findObjectsInBackground { (price: [PFObject]?, error: Error?) in
            if let error = error {
                // The request failed
                print(error.localizedDescription)
            } else if let price = price {
                price.forEach { (price) in
                    print("Successfully retrieved \(String(describing: price["transactionAmount"])).");
                    self.lowestPrice.text = "$\(price["transactionAmount"]!)"
                }
            }
        }
        
        
        let transactionsQuery = PFQuery(className: "Transactions")
        transactionsQuery.whereKey("botName", equalTo: nameOfBot)
        transactionsQuery.whereKey("botType", equalTo: botTypeCopy)
        transactionsQuery.order(byDescending: "timeOfTransaction")
        transactionsQuery.selectKeys(["transactionAmount"])
        transactionsQuery.limit = 1
        
        transactionsQuery.findObjectsInBackground { (price: [PFObject]?, error: Error?) in
            if let error = error {
                // The request failed
                print(error.localizedDescription)
            } else if let price = price {
                price.forEach { (price) in
                    print("Successfully retrieved \(String(describing: price["transactionAmount"])).");
                    self.botPrice.text = "$\(price["transactionAmount"]!)"
                }
            }
        }
        
    }
    
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

