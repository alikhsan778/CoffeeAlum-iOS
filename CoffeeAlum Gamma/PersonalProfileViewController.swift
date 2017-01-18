//
//  ProfileViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/2/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

class PersonalProfileViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var occupationTextField: UITextField!
    
    @IBOutlet weak var employerTextField: UITextField!
    
    @IBOutlet weak var educationalBackgroundTextField: UITextField!
    
    @IBOutlet weak var personalWebsiteTextField: UITextField!
    
    @IBOutlet weak var bioTextField: UITextField!
    
    @IBOutlet weak var linkedInProfileTextField: UITextField!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        
        
    }
    
    override func viewDidLayoutSubviews() {
        // Using the Pan Gesture Recognizer to reveal the "SWRevealViewController"
        setupSidebarMenuPanGesture()
    }
}
