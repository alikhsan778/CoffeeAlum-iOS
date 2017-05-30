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



final class SidebarMenuVC: UIViewController {
    
    
    var thisUser: User?
    // MARK: - IBOutlets
    @IBOutlet var sidebarMenuView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    
    // MARK: - IBActions
    @IBAction func profileButtonAction(_ sender: UIButton) {
      
    }
    
    @IBAction func logOutButtonAction(_ sender: UIButton) {
        APIClient.signOut()
        transitionToSignInVC()
    }
    
    // TODO: putting the following func into button connecting to login
    override func viewDidLoad() {
        
        let thisUserRef = FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid)
        
        thisUserRef.observe(.value, with: { [unowned self](snapshot) in
            self.thisUser = User(snapshot: snapshot)
            
            if let portraitURL = self.thisUser?.portrait {
                let url = URL(string: portraitURL)
                self.profilePicture.sd_setImage(with: url)
                self.profilePicture.circularize()
            }
            
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
    
    fileprivate func transitionToSignInVC() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Instantiate the login view controller
        // Accessing the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // The next view controller
        let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        // Present the next view controller
        appDelegate.window?.rootViewController = signInViewController
    }
    
}
