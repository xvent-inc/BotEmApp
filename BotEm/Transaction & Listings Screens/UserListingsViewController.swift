//
//  UserListingsViewController.swift
//  BotEm
//
//  Created by Julien Calfayan on 5/2/19.
//  Copyright © 2019 Xvent Inc. All rights reserved.
//

import UIKit
import Parse

class UserListingsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var UserListingsCollectionView: UICollectionView!
    
    var listings = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserListingsCollectionView.dataSource = self
        UserListingsCollectionView.delegate = self
        
        let listingsQuery = PFQuery(className: "Listings")
        listingsQuery.whereKey("seller", equalTo: PFUser.current()!)
        
        listingsQuery.findObjectsInBackground { (listings: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.listings = listings!
                self.UserListingsCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.UserListingsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UserListingsCollectionView.dequeueReusableCell(withReuseIdentifier: "UserListingsCollectionViewCell", for: indexPath) as! UserListingsCollectionViewCell
        
        cell.layer.cornerRadius = 35
        
        let listing = listings[indexPath.item]
        
        cell.deleteListingButton?.layer.setValue(indexPath.item, forKey: "index")
        cell.deleteListingButton?.addTarget(self, action: #selector(deleteListing(sender:)), for: .touchUpInside)
                
        var nameOfBot = listing["botName"] as? String
        if nameOfBot == "Project Destroyer" {
            nameOfBot = "Proj. Dest."
        } else if nameOfBot == "TheKickStation" {
            nameOfBot = "TheKickSt."
        }
        
        cell.botName.text = nameOfBot
        
        cell.botType.text = listing["botType"] as? String
        
        let transacAmount = listing["transactionAmount"] as? String
        cell.listingPrice.text = "$" + transacAmount!
        
        let payoutNum = listing["payoutAmount"] as? String
        cell.payoutAmount.lineBreakMode = .byClipping
        cell.payoutAmount.text = "POTENTIAL PAYOUT: $" + payoutNum!
        
        return cell
    }
    
    @objc func deleteListing(sender:UIButton) {
        let i : Int = (sender.layer.value(forKey: "index")) as! Int
        listings[i].deleteInBackground()
        self.viewDidLoad()
        UserListingsCollectionView.reloadData()
    }
}


