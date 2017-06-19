//
//  SidebarMenuViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/30/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import Foundation


final class SidebarMenuVC: UIViewController {
    
    private enum State {
        case `default`
        case loading
        case didLayoutSubviews
        case signOut
    }
    
    private var state: State = .default {
        didSet {
            didChange(state)
        }
    }
    
    private func didChange(_ state: State) {
        switch state {
        case .loading:
            downloadUserData()
        case .didLayoutSubviews:
            addUserProfilePicture()
        case .signOut:
            APIClient.signOut()
            APIClient.googleSignOut()
            presentSignInViewController()
        default:
            break
        }
    }
    
    private var currentUser: User?
    
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
        state = .didLayoutSubviews
    }
    
    private func addUserProfilePicture() {
        guard let profilePictureURL = currentUser?.portrait else {
            return
        }
        
        profilePicture.sd_setImage(with: URL(string: profilePictureURL))
        profilePicture.addCircularFrame()
    }
    
    private func downloadUserData() {
        APIClient.retrieveCurrentUserInformation { (user) in
            self.currentUser = user
        }
    }
    
    private func presentSignInViewController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyboard = UIStoryboard(name: Storyboard.main.rawValue,
                                      bundle: nil)
        let targetViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        // Present the next view controller
        appDelegate.window?.rootViewController = targetViewController
    }
    
}
