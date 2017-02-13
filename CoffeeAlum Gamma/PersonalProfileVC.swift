//
//  ProfileViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/2/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Firebase

class PersonalProfileVC: UIViewController, PersonalProfileDelegate {
    
    // User object
    var thisUser: User!
    // var tags: [Tag] TODO: Implement tag tracking feature; Add tags to search
    
    var userList = [User]()
    
    // MARK: - IBOutlet
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func sideBarMenuButton(_ sender: UIButton) {
        // Connects to the revealToggle method in the SWRevealViewController custom code
        sender.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        // TODO: - Save the user edits
    }

    override func viewDidLoad() {
        // Retreiving the user information
        retrieveUserInfo()
        
    }

    // TODO: Select Tags View
    override func viewDidLayoutSubviews() {
        // Using the Pan Gesture Recognizer to reveal the "SWRevealViewController"
        setupSidebarMenuPanGesture()
    }
    
    /// Method to retrieve user information.
    func retrieveUserInfo() {
        
        // Removing current objects to prevent replication
        userList.removeAll()
        
        // Firebase objects
        let uid = FIRAuth.auth()!.currentUser!.uid
        let reference = FIRDatabase.database().reference()
        let user = reference.child("users").child(uid)
        
        user.queryOrderedByKey().observeSingleEvent(of: .value, with: { [unowned self](snapshot) in
            
            /// Swift doesn't know what snapshot is so we have to cast it into its data type
            // - String is going to be the key
            // - AnyObject is going to be the data
            let userData = snapshot.value as! [String : AnyObject]
            
            // Checks if any of the vital datas fails to be retrievedg
            guard let education = userData["education"] as? String else {
                fatalError("Failed to retrieve user 'education' data")
            }
            
            guard let accountType = userData["account"] as? String else {
                fatalError("Failed to retrieve user 'accountType' data")
            }
            
            guard let location = userData["location"] as? String else {
                fatalError("Failed to retrieve user 'location' data")
            }
            
            guard let name = userData["name"] as? String else {
                fatalError("Failed to retrieve user 'name' data")
            }
           
            // Assigning thisUser to not be nil
            self.thisUser = User(name: "\(name)", account: AccountType(rawValue: accountType)!, education: "\(education)", location: "\(location)")
            
            self.userList.append(self.thisUser)
            
            // Refreshes the table view
            // Must be called in the asynchronous process
            // Will not be effective if called in the main thread
            self.tableView.reloadData()
            
        })

    }
    
    // Saves the user edit
    /*
    func saveButton() {
        // Put nameTextFieldCondition here
        
        thisUser!.name = nameTextField.text ?? ""
        if nameTextField.text!.characters.count < 2 {
            return // TODO: give useful error message
        }
        
        thisUser!.email = emailTextField.text ?? ""
        if !Helper.validate(email: emailTextField.text!){
            return // TODO: give useful error message
        }
        
        thisUser!.role = occupationTextField.text ?? ""
        thisUser!.employer = employerTextField.text ?? ""
        thisUser!.education = educationalBackgroundTextField.text ?? ""
        // thisUser!.website = personalWebsiteTextField.text ?? ""
        // thisUser!.bio = bioTextField.text ?? ""
        thisUser!.linkedIn = linkedInProfileTextField.text ?? ""
        
        if let image = profilePicture.image {
            thisUser!.portrait = image.toString()
        }
        
        thisUser!.save()
    }
    */
    
    // Method to save the updated user information
    func updateUserInformation() {
        thisUser.save()
    }
    
    func addGestures(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.profilePicture.addGestureRecognizer(tap)
    }

}


