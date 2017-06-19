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
    
    enum State {
        case `default`
        case loading
        case signOut
    }
    
    var state: State = .default {
        didSet {
            didChange(state)
        }
    }
    
    func didChange(_ state: State) {
        switch state {
        case .signOut:
            APIClient.signOut()
            APIClient.googleSignOut()
            presentSignInViewController()
        default:
            break
        }
    }
    
    var thisUser: User?
    
    // MARK: - IBOutlets
    @IBOutlet var sidebarMenuView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    
    // MARK: - IBActions
    @IBAction func profileButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func logOutButtonAction(_ sender: UIButton) {
        state = .signOut
    }
    
    // TODO: putting the following func into button connecting to login
    override func viewDidLoad() {
        state = .loading
    }
    
    override func viewDidLayoutSubviews() {
        let thisUserRef = FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid)
        
        thisUserRef.observe(.value, with: { [unowned self](snapshot) in
            self.thisUser = User(snapshot: snapshot)
            
            if let portraitURL = self.thisUser?.portrait {
                let url = URL(string: portraitURL)
                self.profilePicture.sd_setImage(with: url)
                self.profilePicture.addCircularFrame()
            }
            
        })
    }
    
    private func presentSignInViewController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyboard = UIStoryboard(
            name: Storyboard.main.rawValue,
            bundle: nil
        )
        let targetViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        // Present the next view controller
        appDelegate.window?.rootViewController = targetViewController
    }
    
}
