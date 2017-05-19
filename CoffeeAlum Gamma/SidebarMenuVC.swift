//
//  SidebarMenuViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/30/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn


class SidebarMenuVC: UIViewController {
    
    
    var thisUser: User?
    // MARK: - IBOutlets
    @IBOutlet var sidebarMenuView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func profileButtonAction(_ sender: UIButton) {
      
    }
    
    @IBAction func logOutButtonAction(_ sender: UIButton) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Instantiate the login view controller
        // Accessing the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // The next view controller
        let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        // Present the next view controller
        appDelegate.window?.rootViewController = signInViewController
        
    }
    
    // TODO: putting the following func into button connecting to login
    override func viewDidLoad() {
        let thisUserRef = FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid)
        
        thisUserRef.observe(.value, with: { [unowned self](snapshot) in
          self.thisUser = User(snapshot: snapshot)
        })
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
