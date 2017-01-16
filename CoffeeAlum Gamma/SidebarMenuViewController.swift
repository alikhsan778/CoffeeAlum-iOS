//
//  SidebarMenuViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/30/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import Foundation
import FirebaseAuth

class SidebarMenuViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var sidebarMenuView: UIView!
    
    // MARK: - IBActions
    @IBAction func logOutButtonAction(_ sender: UIButton) {
        try! FIRAuth.auth()?.signOut()
        
        // Instantiate the login view controller
        // Accessing the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // The next view controller
        let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        // Present the next view controller
        self.present(signInViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Adding shadows to the profileHeader in the slide menu
        
    }
    
    /*
    override var prefersStatusBarHidden: Bool {
        return true
    }
    */
    
}
