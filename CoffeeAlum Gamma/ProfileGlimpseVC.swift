//
//  ProfileViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/2/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Firebase

final class ProfileGlimpseVC: UIViewController, UIPopoverPresentationControllerDelegate, InviteDelegate {
    
    @IBOutlet weak var meetupButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButtonOutlet: UIButton!
    
    
    // MARK: - Variables
    let mainCells: [String] = [
        "About",
        "Education",
        "LinkedIn",
        "Website"
    ]
    var filteredCells: [String] = []
    var data: [(header: String, expanded: Bool)] = []
    var viewedUser: User?
    var thisUser: User?
    
    override func viewDidLoad() {
        
        filteredCells = mainCells.filter { header -> Bool in
            return includeData(header: header)
        }
        
        data = filteredCells.map{
            ($0, false)
        }
        
        setupCloseButton()
    }
    
    override func viewDidLayoutSubviews() {
        
        occupationLabel.text = viewedUser!.employer
        locationLabel.text = viewedUser!.location
        usernameLabel.text = viewedUser!.name
        
        if viewedUser!.uid == FIRAuth.auth()?.currentUser!.uid{
            meetupButton.isHidden = true
        } else{
            meetupButton.isHidden = false
        }
        
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
    
    fileprivate func setupCloseButton() {
        closeButtonOutlet.layer.cornerRadius = closeButtonOutlet.frame.width / 2
    }
    
}
