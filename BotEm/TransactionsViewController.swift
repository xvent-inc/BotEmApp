//
//  TransactionsViewController.swift
//  BotEm
//
//  Created by Julien Calfayan on 5/1/19.
//  Copyright © 2019 Xvent Inc. All rights reserved.
//

import UIKit
import Parse

class TransactionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var transactionsCollectionView: UICollectionView!
    @IBOutlet weak var yourListingsButton: UIButton!
    
    var transactions = [PFObject]()
    
    let closedStatusColor = UIColor(hex: "#E3204Aff")
    let payoutSentStatusColor = UIColor(hex: "#30AE5Eff")
    let awaitingKeyStatusColor = UIColor(hex: "#8825B0ff")
    let pendingStatusColor = UIColor(hex: "#FFAA22ff")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yourListingsButton.layer.cornerRadius = 20

        transactionsCollectionView.delegate = self
        transactionsCollectionView.dataSource = self
        
        /*
                MAKE SURE TO CHANGE "WHEREKEY" BELOW TO SELLER INSTEAD OF AUTHOR AFTER PURCHASING CODING IS DONE. SUBMIT THE TRANSACTION TO SERVER WITH INFO FOR BUYER AND SELLER.
         
                THE COMMENTS BELOW THE "WHEREKEY" IS WHAT SHOULD BE USED.
         
                ALSO USE UNIX EPOCH TO KEEP TRACK OF LATEST TRANSACTIONS FOR THE BOTS (CODE FOR UNIX BELOW)
                let timeinterval = Int(NSDate().timeIntervalSince1970)
         */
        
        let transactionsQuery = PFQuery(className: "Transactions")
        transactionsQuery.whereKey("author", equalTo: PFUser.current()!)
        //transactionsQuery.whereKey("seller", equalTo: PFUser.current()!)
        //transactionsQuery.whereKey("buyer", equalTo: PFUser.current()!)
        transactionsQuery.limit = 20
        
        transactionsQuery.findObjectsInBackground { (transactions: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.transactions = transactions!
                self.transactionsCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.transactionsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = transactionsCollectionView.dequeueReusableCell(withReuseIdentifier: "TransactionCollectionViewCell", for: indexPath) as! TransactionCollectionViewCell
        
        cell.layer.cornerRadius = 35
        
        let transaction = transactions[indexPath.item]
        
        var nameOfBot = transaction["botName"] as? String
        if nameOfBot == "Project Destroyer" {
            nameOfBot = "Proj. Dest."
        } else if nameOfBot == "TheKickStation" {
            nameOfBot = "TheKickSt."
        }
        
        cell.botName.text = nameOfBot
        
        cell.botType.text = transaction["botType"] as? String
        cell.transactionType.text = transaction["transactionType"] as? String
        
        let transacAmount = transaction["transactionAmount"] as? String
        cell.transactionAmount.text = "$" + transacAmount!
        
        let payoutNum = transaction["payoutAmount"] as? String
        cell.payoutAmount.lineBreakMode = .byClipping
        cell.payoutAmount.text = "PAYOUT: $" + payoutNum!
        
        cell.transactionNumber.text = transaction["transactionNumber"] as? String
        
        let statusOfTransaction = transaction["transactionStatus"] as? String
        
        if statusOfTransaction == "PENDING" {
            cell.transactionStatus.textColor = pendingStatusColor
        } else if statusOfTransaction == "CLOSED" {
            cell.transactionStatus.textColor = closedStatusColor
        } else if statusOfTransaction == "PAYOUT SENT"{
            cell.transactionStatus.textColor = payoutSentStatusColor
        } else if statusOfTransaction == "AWAITING KEY" {
            cell.transactionStatus.textColor = awaitingKeyStatusColor
        } else {
            cell.transactionStatus.textColor = pendingStatusColor
        }
        
        cell.transactionStatus.text = statusOfTransaction
        
        return cell
    }
}
