//
//  ProfileViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/2/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Firebase

class ProfileGlimpseVC: UIViewController, UIPopoverPresentationControllerDelegate, InviteDelegate {
    
    @IBOutlet weak var meetupButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Variables
    let mainCells: [String] = ["About", "Education", "LinkedIn", "Website"]
    var filteredCells: [String] = []
    var data: [(header: String, expanded: Bool)] = []
    var viewedUser: User?
    var thisUser: User?
    
    override func viewDidLoad() {
        filteredCells = mainCells.filter({ header -> Bool in
            return includeData(header: header)
        })
        data = filteredCells.map{($0, false)}
    }
    
    override func viewDidLayoutSubviews() {
        
        self.occupationLabel.text = viewedUser!.employer
        self.locationLabel.text = viewedUser!.location
        self.usernameLabel.text = viewedUser!.name
        
        self.setupRevealViewController()
        
        if self.viewedUser!.uid == FIRAuth.auth()?.currentUser!.uid{
            self.meetupButton.isHidden = true
        } else{
            meetupButton.isHidden = false
        }
        
    }
    
    @IBAction func meetupButtonAction(_ sender: UIButton) {
        // Setting up popover for invitation view controller
        setupPopover(viewedUser: self.viewedUser!)
    }
    
    func includeData(header: String) -> Bool{
        var selected: String
        switch header {
        case "About":
            selected = viewedUser!.bio
        case "Education":
            selected = viewedUser!.education
        case "LinkedIn":
            selected = viewedUser!.linkedIn
        case "Website":
            selected = viewedUser!.website
        default:
            selected = viewedUser!.linkedIn
        }
        return selected != ""
    }
    
}
