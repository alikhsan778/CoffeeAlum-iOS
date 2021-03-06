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
    
    enum State {
        case `default`
    }
    
    var state: State = .default {
        didSet {
            didChange(state)
        }
    }
    
    func didChange(_ state: State) {
        
    }
    
    @IBOutlet weak var meetupButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButtonOutlet: UIButton!
    @IBOutlet weak var meetupButtonContainer: UIView!
    
    
    // MARK: - Variables
    let mainCells: [String] = [
        "About",
        "Education",
        "LinkedIn",
        "Website"
    ]
    var filteredCells: [String] = []
    var data: [(header: String, expanded: Bool)] = []
    var userViewed: User?
    var thisUser: User?
    private var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        
        filteredCells = mainCells.filter { (header) -> Bool in
            return includeData(header: header)
        }
        
        data = filteredCells.map {
            ($0, false)
        }
        
        setupCloseButton()
    }
    
    override func viewDidLayoutSubviews() {
        
        guard let userViewed = userViewed else {
            return
        }
        
        occupationLabel.text = userViewed.employer
        locationLabel.text = userViewed.location
        usernameLabel.text = userViewed.name
        
        let url = URL(string: userViewed.portrait)
        profilePicture.sd_setImage(with: url)
        profilePicture.addCircularFrame()
        
        if userViewed.uid == FIRAuth.auth()?.currentUser!.uid{
            meetupButton.isHidden = true
            meetupButtonContainer.isHidden = true
        }
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func meetupButtonAction(_ sender: UIButton) {
        // Setting up popover for invitation view controller
        setupPopover(userViewed: self.userViewed!)
    }
    
        
    private func includeData(header: String) -> Bool {
        
        guard let userViewed = userViewed else {
            return false
        }
        
        var selected: String
        
        switch header {
        case "About":
            selected = userViewed.bio
        case "Education":
            selected = userViewed.education
        case "LinkedIn":
            selected = userViewed.linkedIn
        case "Website":
            selected = userViewed.website
        default:
            selected = userViewed.linkedIn
        }
        
        return selected != ""
    }
    
    private func setupCloseButton() {
        closeButtonOutlet.layer.cornerRadius = closeButtonOutlet.frame.width / 2
    }
}
