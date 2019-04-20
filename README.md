# BotEm by Xvent

## Table of Contents
1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)
5. [Current Progress](#Current-Progress)

## Overview
### Description
Organized marketplace for streetwear/sneaker bots. Serves as a middle-man between resellers and buyers. Verifies that bot licenses are valid and unlinked so there are no scams. App will hold money until license is verified. Resellers will be given ratings.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Mobile Marketplace
- **Mobile:** This app would originally be used on mobile but could later be upgraded to be used on a computer similar to eBay.
- **Story:** Connect bot resellers to interested buyers and provide verification for bot licenses to prevent scams.
- **Market:** People who want to buy streetwear bots.
- **Habit:** A seller could sell as often as they like, but it is expected that buyers will be searching the app daily.
- **Scope:** The current goal is to create a martetplace for streetwear bots, but the idea could be expanded to all kinds of bots such as customer service bots.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can login
* User can create an account
* User can list a bot to sell
* User can buy a bot
* User can view status update regarding bot verification

**Optional Nice-to-have Stories**

* User can search for specific bots
* Recommended bots based on bots user was interested in
* User can follow a bot seller
* User can see a list of what else the seller is selling
* User can bookmark/watch a bot
* User can negotiate the price of a bot with the seller
* User can give the seller a review
* User can give a review for a specific bot
* User can view how efficient the bot is
* User can connect social media accounts to app
* User can share listing through social media

### 2. Screen Archetypes

* Login Screen
   * User can login
* Sign up screen
   * User can create an account
* Stream Screen
   * User can view bots for sale
* Detail Screen
   * User can see information about bot
       * User can see price
       * User can see what bot is used to buy
* Sell Screen
   * User can list their bot
* Transactions Screen
   * User can view the statuses of their past purchases and sales made through the app
* Listings Screen
   * User can view their active listings
* Account Screen
   * User can change their profile picture and password
* Change Password Screen
   * User can change their account password

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home
* Account
* Transactions

**Flow Navigation** (Screen to Screen)

* Login Screen
   > Home (Stream Screen)

   > Sign Up Screen
* Sign up screen
   > Login Screen
* Stream Screen (Home)
   > Detail
* Detail Screen
   > Sell Screen

   > Transactions Screen
* Sell Screen
   > Listings Screen
* Transactions Screen
   > Listings Screen
* Listings Screen
   > None
* Account Screen
   > Change Password Screen

   > Image Picker (User Profile Photo)
* Change Passwrod Screen
   > Account Screen
   
## Wireframes
<img src="https://i.imgur.com/LqSEFs7.jpg" width=600>


### [BONUS] Digital Wireframes & Mockups!

<img src="https://i.imgur.com/Uh15kDT.jpg" width=600>

### [BONUS] Interactive Prototype!
<img src="https://i.imgur.com/FgAKmXD.gif" width=200>


## Schema 
### Models

**User**

| Property | Type | Description |
| -------- | -------- | -------- |
| userID     | String     | unique identifier for user |
| firstName     | String | user first name |
| lastName     | String | user last name |
| username     | String | user username |
| email     | String | user email address |
| password     | Hash String | user password |
| profilePicture | File | user picture |

**Transaction**

| Property | Type | Description |
| -------- | -------- | -------- |
| transactionID | Number | unique identifier for transaction |
| status | String | status of the listings |
| price | Number | price of bot |
| lowestPrice | Number | lowest price of bot |
| payout | Number | bot sold price |
| typeOfBot | String | Lifetime or renewal |





### Networking

* Login Screen
   * (Read/`GET`) Query for username and password match
        ```
        @IBAction func onSignin(_ sender: Any) {
            let username = usernameField.text!
            let password = passwordField.text!


            PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                if user != nil {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } else {
                    print("Error: \(error?.localizedDescription)")            }
            }
        }
        ```
* Reset Password Screen
   * (Read/`GET`) Have server send reset passwrod request to user's email
        ```
        @IBAction func onResetPass(_ sender: Any) {
            let email = emailField.text!

            PFUser.requestPasswordResetForEmailInBackground(email)
        }
        ```
* Sign up Screen
   * (Create/`POST`) Create a new user account
        ```
        @IBAction func onSignup(_ sender: Any) {
            var user = PFUser()
            user.username = usernameSignUpField.text
            user.password = passwordSignUpField.text
            user.email = emailSignUpField.text

            user["firstName"] = firstNameSignUpField.text
            user["lastName"] = lastNameSignUpField.text

            let imageData = UIImage(named: "noProfilePicture")!.pngData()
            let file = PFFileObject(data: imageData!)

            user["profilePicture"] = file

            user.signUpInBackground { (success, error) in
                if success {
                   self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } else {
                    print("Error: \(error?.localizedDescription)")
                }
            }   
        }
        ```
* Stream Screen
   * (Read/`GET`) Query bot Image for lifetime and renewal bots
        ```
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            if collectionView == self.LifetimeBotsCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LifetimeBotsCollectionViewCell", for: indexPath) as! LifetimeBotsCollectionViewCell

                let lifetimeBot = lifetimeBots[indexPath.row]

                let imageFile = lifetimeBot["image"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!

                cell.lifetimeBotImageView.af_setImage(withURL: url)

                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RenewableBotsCollectionViewCell", for: indexPath) as! RenewableBotsCollectionViewCell

                let renewableBot = renewableBots[indexPath.row]

                let imageFile = renewableBot["image"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)!

                cell.renewableBotImageView.af_setImage(withURL: url)

                return cell
            }
        }
        ```
* Detail Screen
   * (Read/`GET`) Query for lowest bot price and bot description
        ```
        override func viewDidLoad() {
            let imageFile = bot["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!

            botPhotoView.af_setImage(withURL: url)

            botNameLabel.text = bot["name"] as? String
            botPriceLabel.text = bot["currentPrice"] as? String
            descriptionLabel.text = bot["description"] as? String
        }
        ```
* Sell Screen
   * (Create/`POST`) Create a new bot listing
   * (Create/`POST`) Create a new price for bot
    ```
    @IBAction func onListButton(_ sender: Any) {
        let botListing = PFObject(className: "Bots")

        botListing["price"] = priceTextField.text!
        botListing["seller"] = PFUser.current()!
        botListing["bot"] = bot["name"] as? String

        botListing.saveInBackground() { (success, error) in
            if success {
                _ = self.navigationController?.popToRootViewController(animated: true)
                print("Post Saved!")
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    ```
* Transactions Screen
   * (Read/`GET`) Query all transactions 
        ```
        func tableView(_ tableView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UITableViewCell {

            if tableView == self.PurchasesTableView {
                let cell = tableView.dequeueReusableCell(withReuseIdentifier: "PurchasesTableViewCell", for: indexPath) as! PurchasesTableViewCell

                let purchase = purchases[indexPath.row]

                cell.botNameLabel.text = purchase["bot"] as? String
                cell.transactionTypeLabel.text = "PURCHASE"
                cell.botTypeLabel.text = purchase["botType"] as? String
                cell.priceLabel.text = purchase["price"] as? String
                cell.statusLabel.text = purchase["status"] as? String
                // change color of label if equal to certain text

                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withReuseIdentifier: "SalesTableViewCell", for: indexPath) as! SalesTableViewCell

                let sale = sales[indexPath.row]

                cell.botNameLabel.text = sale["bot"] as? String
                cell.transactionTypeLabel.text = "SALE"
                cell.botTypeLabel.text = sale["botType"] as? String
                cell.priceLabel.text = sale["price"] as? String
                cell.statusLabel.text = sale["status"] as? String
                // change color of label if equal to certain text

                let price = sale["price"] 
                let transactionFee = price * 0.095
                let paymentProcFee = price * 0.03
                let payout = price - transactionFee - paymentProcFee

                cell.payoutLabel.text = payout as? String

                return cell
            }
        }
        ```
* Listings Screen
   * (Read/`GET`) Query all listings
        ```
        func tableView(_ tableView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withReuseIdentifier: "ListingsTableViewCell", for: indexPath) as! ListingsTableViewCell

            let listing = listings[indexPath.row]

            cell.botNameLabel.text = listing["bot"] as? String
            cell.transactionTypeLabel.text = "LISTING"
            cell.botTypeLabel.text = listing["botType"] as? String
            cell.statusLabel.text = "UP FOR SALE"

            let price = sale["price"] 
            let transactionFee = price * 0.095
            let paymentProcFee = price * 0.03
            let payout = price - transactionFee - paymentProcFee

            cell.payoutLabel.text = payout as? String

            @IBAction func onCancelButton(_ sender: Any) {
                listing.deleteInBackground
            }

            return cell
        }
        ```
* Account Screen
   * (Update/`PUT`) Update user profile picture
   * (Read/`GET`) Query profile picture, first name, last name, and username
    ```
    override func viewDidLoad() {
        let imageFile = user?["profilePicture"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!

        profilePicture.layer.cornerRadius = 50
        profilePicture.clipsToBounds = true
        profilePicture.af_setImage(withURL: url)

        usernameLabel.text = user?.username
        firstNameLabel.text = user["firstName"] as? String
        lastNameLabel.text = user["lastName"] as? String
    }

    @IBAction func setPictureButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true

        picker.sourceType = .photoLibrary

        present(picker, animated: true, completion: nil)
    }

    @objc func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage

        let size = CGSize(width: 250, height: 250)
        let scaledImage = image.af_imageAspectScaled(toFill: size)

        profilePicture.image = scaledImage

        let imageData = profilePicture.image!.pngData()
        let file = PFFileObject(data: imageData!)

        user?["profilePicture"] = file

        user?.saveInBackground() { (success, error) in
            if success {
                print("Profile Picture Saved!")
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }

        dismiss(animated: true, completion: nil)
    }
    ```
* Change Password Screen
   * (Update/`PUT`) Update user password
   * (Read/`GET`) Query user's current password
    ```
    @IBAction func onChangePass(_ sender: Any) {
        if (currentPassField.text == user?.password as? String) {

            user?.password = currentPassField.text as? String

            user?.saveInBackground { (success, error) in
                if success {
                    print("Password Changed!")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
        else {
            print("Current Password Incorrect.")
        }
    }
    ```
## Current Progress
<img src="http://g.recordit.co/HAnorspWXf.gif" width=200>

[x] Login Screen

[x] Sign up screen

[x] Stream Screen (Home)

[x] Detail Screen

[x] Sell Screen

[x] Account Screen

[x] Change Passwrod Screen
