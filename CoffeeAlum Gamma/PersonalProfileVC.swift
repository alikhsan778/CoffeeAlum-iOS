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

    private enum State {
        case `default`
        case loading
    }
    
    private var state: State = .default {
        didSet {
            didChange(state)
        }
    }
    
    private func didChange(_ state: State) {
        switch state {
        case .loading:
            retrieveAllUserData()
            sidebarMenuButton.setupSidebarButtonAction(to: self)
            setupRevealViewController()
            addProfilePictureTapGesture()
        default:
            break
        }
    }
    
    var userList = [User]()
    
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
    func retrieveAllUserData() {
        // Removing current objects to prevent duplication
        userList.removeAll()
        
        APIClient.downloadAllUserData { (listOfUsers) in
            self.userList = listOfUsers
            self.tableView.reloadData()
        }
    }
    
    // Delegate method to save the updated user information
    func save(user update: User) {
        APIClient.save(update) { (error) in
            self.retrieveAllUserData()
        }
    }
    
    fileprivate func addProfilePictureTapGesture() {
        profilePicture.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(imageTapped))
        profilePicture.addGestureRecognizer(tapGestureRecognizer)
    }

}


