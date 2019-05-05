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
    
    let purchaseBorder = UIColor(hex: "#3AC2A0ff")
    let saleBorder = UIColor(hex: "#FDCF70ff")
    let errorBorder = UIColor(hex: "#D31F49ff")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yourListingsButton.layer.cornerRadius = 20

        transactionsCollectionView.delegate = self
        transactionsCollectionView.dataSource = self
        
        
        let sellerQuery = PFQuery(className:"Transactions")
        sellerQuery.whereKey("seller", equalTo: PFUser.current()!)
        
        let buyerQuery = PFQuery(className:"Transactions")
        buyerQuery.whereKey("buyer", equalTo: PFUser.current()!)
        
        let transactionsQuery = PFQuery.orQuery(withSubqueries: [sellerQuery, buyerQuery])
        transactionsQuery.findObjectsInBackground { (transactions: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.transactions = transactions!
                self.transactionsCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
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
        
        let sellerEmail = transaction["sellerEmail"] as! String
        let buyerEmail = transaction["buyerEmail"] as! String
        
        if (sellerEmail == PFUser.current()?.email && buyerEmail == PFUser.current()?.email){
            cell.transactionType.text = "Why Your Own?"
            cell.payoutAmount.text = ""
            cell.layer.borderWidth = 3
            cell.layer.borderColor = errorBorder?.cgColor
        } else if (buyerEmail == PFUser.current()?.email){
            cell.transactionType.text = "PURCHASE"
            cell.payoutAmount.text = ""
            cell.layer.borderWidth = 3
            cell.layer.borderColor = purchaseBorder?.cgColor
        } else if (sellerEmail == PFUser.current()?.email) {
            cell.transactionType.text = "SALE"
            let payoutNum = transaction["payoutAmount"] as? String
            cell.payoutAmount.lineBreakMode = .byClipping
            cell.payoutAmount.text = "PAYOUT: $" + payoutNum!
            cell.layer.borderWidth = 3
            cell.layer.borderColor = saleBorder?.cgColor
        }
        
        cell.botName.text = nameOfBot
        cell.botType.text = transaction["botType"] as? String
        let transacAmount = transaction["transactionAmount"] as? String
        cell.transactionAmount.text = "$" + transacAmount!
        let transacNumber = transaction["transactionNumber"] as! Int
        cell.transactionNumber.text = String(transacNumber)
        
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
        
        //self.viewDidLoad()
        
        return cell
    }
}
