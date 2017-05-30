//
//  ProfileViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/2/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Firebase


final class PersonalProfileVC: UIViewController, PersonalProfileDelegate {
    
    // User object
    var thisUser: User!
    // var tags: [Tag] TODO: Implement tag tracking feature; Add tags to search
    var userList = [User]()
    var fileteredUserSet = Set<User>()
    
    // MARK: - IBOutlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sidebarMenuButton: UIButton!


    override func viewDidLoad() {
        // Retreiving the user information
        retrieveUserInfo()
        // Setup sidebar button
        sidebarMenuButton.setupSidebarMenuButton(to: self)
        
        let nibFile = UINib(
            nibName: "PersonalProfileTableViewCell",
            bundle: nil
        )
        tableView.register(
            nibFile,
            forCellReuseIdentifier: "PersonalProfileCell"
        )
    }

    // TODO: Select Tags View
    override func viewDidLayoutSubviews() {
        // Using the Pan Gesture Recognizer to reveal the "SWRevealViewController"
        self.setupRevealViewController()
    }
    
    
    @IBAction func sideBarMenuButton(_ sender: UIButton) {
        
        
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        
    }
    
    /// Method to retrieve user information.
    func retrieveUserInfo() {
        
        // Removing current objects to prevent duplication
        userList.removeAll()
        fileteredUserSet.removeAll()
        
        // Firebase objects
        let uid = FIRAuth.auth()!.currentUser!.uid
        let reference = FIRDatabase.database().reference()
        let user = reference.child("users").child(uid)
        
        user.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.thisUser = User(snapshot: snapshot)
            
            self.fileteredUserSet.insert(self.thisUser)
            
            // TODO: Use a set
            self.userList.append(
                contentsOf: Array(self.fileteredUserSet)
            )
            
            // Refreshes the table view
            // Must be called in the asynchronous process
            // Will not be effective if called in the main thread
            self.tableView.reloadData()
            
        })

    }
    
    // Delegate method to save the updated user information
    func updateUserInformation(with user: User) {
        APIClient.saveUserInformation(with: user)
        retrieveUserInfo()
    }
    
    func addGestures(){
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(imageTapped)
        )
        self.profilePicture.addGestureRecognizer(tap)
    }

}


