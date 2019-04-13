//
//  StreamViewController.swift
//  BotEm
//
//  Created by RACHEL WURMBRAND on 4/12/19.
//  Copyright © 2019 Xvent Inc. All rights reserved.
//

import UIKit

class StreamViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var lifetimeBotCollection: UICollectionView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StreamViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = lifetimeBotCollection.dequeueReusableCell(withReuseIdentifier: "lifetimeBot", for: indexPath)
        as? LifetimeBotCollectionViewCell
        cell?.lifetimeBotImage.image = Image(indexPath.row) // problem here, change to image
        return cell!
    }
    
    
}
