//
//  StreamViewController.swift
//  BotEm
//
//  Created by RACHEL WURMBRAND on 4/12/19.
//  Copyright © 2019 Xvent Inc. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class StreamViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var renewalBotCollection: UICollectionView!
    @IBOutlet weak var lifetimeBotCollection: UICollectionView!
    
    
    var lifetimeBots = [PFObject]()
    var renewalBots = [PFObject]()

    
    let lifetimeBorder = UIColor(hex: "#3AC2A0ff")
    let renewalBorder = UIColor(hex: "#FDCF70ff")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lifetimeBotCollection.delegate = self
        lifetimeBotCollection.dataSource = self
        
        renewalBotCollection.delegate = self
        renewalBotCollection.dataSource = self
        
        let lifetimeQuery = PFQuery(className: "LifetimeBots")
        lifetimeQuery.includeKeys(["BotName", "BotImage", "BotDescription", "BotPrice", "BotLastSoldPrice"])
        lifetimeQuery.limit = 10
        
        lifetimeQuery.findObjectsInBackground { (lifetimeBots, error) in
            if lifetimeBots != nil {
                self.lifetimeBots = lifetimeBots!
                self.lifetimeBotCollection.reloadData()
            } else {
                
            }
        }
        
        let renewalQuery = PFQuery(className: "RenewalBots")
        renewalQuery.includeKeys(["BotName", "BotImage", "BotDescription", "BotPrice", "BotLastSoldPrice"])
        renewalQuery.limit = 10
        
        renewalQuery.findObjectsInBackground { (renewalBots, error) in
            if renewalBots != nil {
                self.renewalBots = renewalBots!
                self.renewalBotCollection.reloadData()
            } else {
                
            }
        }
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.lifetimeBotCollection) {
            return lifetimeBots.count
        } else {
            return renewalBots.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == self.lifetimeBotCollection) {
            let lifetimeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifetimeBotCell", for: indexPath) as! LifetimeBotCell
            
            let lifetimeBot = lifetimeBots[indexPath.item]
            
            let lifetimeImageFile = lifetimeBot["BotImage"] as! PFFileObject
            let lifetimeUrlString = lifetimeImageFile.url!
            let url = URL(string: lifetimeUrlString)!
            
            lifetimeCell.lifetimeBotImage.af_setImage(withURL: url)
            lifetimeCell.layer.cornerRadius = 125
            lifetimeCell.layer.borderWidth = 5
            lifetimeCell.layer.borderColor = lifetimeBorder?.cgColor
            
            return lifetimeCell
        } else {
            let renewalCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RenewalBotCell", for: indexPath) as! RenewalBotCell
            
            let renewableBot = renewalBots[indexPath.item]
            
            let renewalImageFile = renewableBot["BotImage"] as! PFFileObject
            let renewalUrlString = renewalImageFile.url!
            let url = URL(string: renewalUrlString)!
            
            renewalCell.renewalBotImage.af_setImage(withURL: url)
            renewalCell.layer.cornerRadius = 125
            renewalCell.layer.borderWidth = 5
            renewalCell.layer.borderColor = renewalBorder?.cgColor
            
            return renewalCell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsViewController = segue.destination as! DetailsViewController
        
        if (segue.identifier == "lifetimeBotSegue") {
            let cell = sender as! UICollectionViewCell
            let indexPath = lifetimeBotCollection.indexPath(for: cell)!
            let bot = lifetimeBots[indexPath.item]
            let botType = "Lifetime"
            
            detailsViewController.bot = bot
            detailsViewController.imageBorder = UIColor(hex: "#3AC2A0ff")
            detailsViewController.botType = botType
        } else {
            let cell = sender as! UICollectionViewCell
            let indexPath = renewalBotCollection.indexPath(for: cell)!
            let bot = renewalBots[indexPath.item]
            let botType = "Renewal"
            
            detailsViewController.bot = bot
            detailsViewController.imageBorder = UIColor(hex:"#FDCF70ff")
            detailsViewController.botType = botType
        }
    }
}

extension UIColor {
    convenience init(hex:String, alpha:CGFloat = 1.0) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
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

