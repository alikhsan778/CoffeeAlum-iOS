//
//  ProfileViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/2/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Firebase
import SDWebImage


final class PersonalProfileVC: UIViewController, PersonalProfileDelegate {

    enum State {
        case `default`
        case loading
    }
    
    var state: State = .default {
        didSet {
            didChange(state)
        }
    }
    
    func didChange(_ state: State) {
        switch state {
        case .loading:
            retrieveUserInfo()
            sidebarMenuButton.setupSidebarButtonAction(to: self)
            setupRevealViewController()
            addProfilePictureTapGesture()
        default:
            break
        }
    }
    
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
        state = .loading
        

        let nibFile = UINib(
            nibName: "PersonalProfileTableViewCell",
            bundle: nil
        )
        tableView.register(
            nibFile,
            forCellReuseIdentifier: "PersonalProfileCell"
        )
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
            
            let profilePictureURL = URL(string: self.thisUser.portrait)
            
            if profilePictureURL?.absoluteString != nil {
                self.profilePicture.sd_setImage(with: profilePictureURL)
                self.profilePicture.addCircularFrame()
            }
            
            // Refreshes the table view
            // Must be called in the asynchronous process
            // Will not be effective if called in the main thread
            self.tableView.reloadData()
        })

    }
    
    // Delegate method to save the updated user information
    func save(user update: User) {
        APIClient.save(update) { (error) in
            
        }
        retrieveUserInfo()
    }
    
    fileprivate func addProfilePictureTapGesture() {
        profilePicture.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(imageTapped))
        profilePicture.addGestureRecognizer(tapGestureRecognizer)
    }

}


