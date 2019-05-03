//
//  UserListingsCollectionViewCell.swift
//  BotEm
//
//  Created by Julien Calfayan on 5/2/19.
//  Copyright © 2019 Xvent Inc. All rights reserved.
//

import UIKit

class UserListingsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var botName: UILabel!
    @IBOutlet weak var botType: UILabel!
    @IBOutlet weak var listingPrice: UILabel!
    @IBOutlet weak var payoutAmount: UILabel!
    @IBOutlet weak var deleteListingButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        deleteListingButton.layer.cornerRadius = 10
    }
}
