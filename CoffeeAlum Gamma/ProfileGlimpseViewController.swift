//
//  ProfileViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/2/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

class ProfileGlimpseViewController: UIViewController {
    
    @IBAction func meetupButtonAction(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var occupationLabel: UILabel!
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    // TESTING CELLS
    let mainCells: [String] = ["About", "Experience", "Interests", "Projects"]
    
    override func viewDidLoad() {
       
    }
    
    override func viewDidLayoutSubviews() {
        setupSidebarMenuPanGesture()
    }
    
}
