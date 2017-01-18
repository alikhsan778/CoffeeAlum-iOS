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
    
    //Missing

    
    
    // TESTING CELLS
    let mainCells: [String] = ["About", "Education", "LinkedIn", "Website"]
    var data: [(header: String, expanded: Bool)] = []
    
    
    
    override func viewDidLoad() {
        data = mainCells.map{($0, false)}
        
    }
    
    override func viewDidLayoutSubviews() {
        setupSidebarMenuPanGesture()
    }
    
}
