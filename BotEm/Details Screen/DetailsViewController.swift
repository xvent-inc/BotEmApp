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
    
    var user = PFUser.current()
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
        
        let listingsQuery = PFQuery(className: "Listings")
        listingsQuery.whereKey("botName", equalTo: nameOfBot)
        listingsQuery.whereKey("botType", equalTo: botTypeCopy)
        listingsQuery.order(byAscending: "transactionAmount")
        listingsQuery.selectKeys(["transactionAmount"])
        listingsQuery.limit = 1
        
        listingsQuery.findObjectsInBackground { (listing: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let listing = listing {
                listing.forEach { (listing) in
                    print("Successfully retrieved \(String(describing: listing["transactionAmount"])).");
                    self.lowestPrice.text = "$\(listing["transactionAmount"]!)"
                }
            }
        }
        
        
        let transactionsQuery = PFQuery(className: "Transactions")
        transactionsQuery.whereKey("botName", equalTo: nameOfBot)
        transactionsQuery.whereKey("botType", equalTo: botTypeCopy)
        transactionsQuery.order(byDescending: "timeOfTransaction")
        transactionsQuery.selectKeys(["transactionAmount"])
        transactionsQuery.limit = 1
        
        transactionsQuery.findObjectsInBackground { (listing: [PFObject]?, error: Error?) in
            if let error = error {
                // The request failed
                print(error.localizedDescription)
            } else if let listing = listing {
                listing.forEach { (listing) in
                    print("Successfully retrieved \(String(describing: listing["transactionAmount"])).");
                    self.botPrice.text = "$\(listing["transactionAmount"]!)"
                }
            }
        }
        
    }
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        /*let listingToPurchaseQuery = PFQuery(className: "Listings")
        listingToPurchaseQuery.whereKey("botName", equalTo: nameOfBot)
        listingToPurchaseQuery.whereKey("botType", equalTo: botTypeCopy)
        listingToPurchaseQuery.order(byAscending: "transactionAmount")
        listingToPurchaseQuery.limit = 1
        
        listingToPurchaseQuery.findObjectsInBackground { (listingToPurchase, error) in
            if listingToPurchase != nil {
                self.listingToPurchase = listingToPurchase
            } else {
            }
        }*/
        
        let transaction = PFObject(className: "Transactions")
        
        let listingsQuery = PFQuery(className: "Listings")
        listingsQuery.whereKey("botName", equalTo: nameOfBot)
        listingsQuery.whereKey("botType", equalTo: botTypeCopy)
        listingsQuery.order(byAscending: "transactionAmount")
        listingsQuery.limit = 1
        
        listingsQuery.findObjectsInBackground { (listings: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let listings = listings {
                for listing in listings {
                    transaction["seller"] = listing["seller"]
                    transaction["sellerEmail"] = listing["sellerEmail"]
                    transaction["payoutAmount"] = listing["payoutAmount"] as? String
                    transaction["transactionAmount"] = listing["transactionAmount"] as? String
                    transaction["paymentProcFee"] = listing["paymentProcFee"] as? String
                    transaction["transactionFee"] = listing["transactionFee"] as? String
                    transaction["buyer"] = self.user
                    transaction["buyerEmail"] = self.user?.email
                    transaction["botName"] = self.bot["BotName"] as? String
                    transaction["botType"] = self.botType.uppercased()
                    transaction["transactionNumber"] = String(Int.random(in: 10000 ..< 99999))
                    transaction["timeOfTransaction"] = String(Int(NSDate().timeIntervalSince1970))
                    transaction["transactionStatus"] = "PENDING"
                    
                    
                    transaction.saveInBackground() { (success, error) in
                        if success {
                            print("Transaction Made!")
                            listing.deleteInBackground()
                        } else {
                            print("Error: \(String(describing: error?.localizedDescription))")
                        }
                    }
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

