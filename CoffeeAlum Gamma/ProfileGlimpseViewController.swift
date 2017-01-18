//
//  ProfileViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/2/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

class ProfileGlimpseViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBAction func meetupButtonAction(_ sender: UIButton) {
        // Setting up popover for invitation view controller
        setupPopover()
    }
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //Missing

    
    
    // VARS
    let mainCells: [String] = ["About", "Education", "LinkedIn", "Website"]
    var filteredCells: [String] = []
    var data: [(header: String, expanded: Bool)] = []
    var user: User?
    
    
    
    override func viewDidLoad() {
        filteredCells = mainCells.filter({ header -> Bool in
            return includeData(header: header)
        })
        data = filteredCells.map{($0, false)}
    }
    
    override func viewDidLayoutSubviews() {
        self.occupationLabel.text = user!.employer
        self.locationLabel.text = user!.location
        self.usernameLabel.text = user!.name
        setupSidebarMenuPanGesture()
    }
    
    func includeData(header: String) -> Bool{
        var selected: String
        switch header {
        case "About":
            selected = user!.bio
        case "Education":
            selected = user!.education
        case "LinkedIn":
            selected = user!.linkedIn
        case "Website":
            selected = user!.website
        default:
            selected = user!.linkedIn
        }
        return selected != ""
    }
    
}
