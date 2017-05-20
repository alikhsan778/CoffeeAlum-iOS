//
//  InvitationViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/16/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation


class InvitationVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var personInvitingLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    var invitation: (coffee: Coffee, user: User)!
    var invitationID: String!
    
    override func viewDidLoad() {
        
        setupUIElements()
        
        // Assigning the invitation ID
        invitationID = invitation?.coffee.id
        
    }
    
    func setupUIElements() {
        personInvitingLabel.text = invitation?.coffee.fromName
        dateAndTimeLabel.text = invitation?.coffee.date
        placeLabel.text = invitation?.coffee.location
    }
    
    // MARK: - IBActions
    @IBAction func declineButtonAction(_ sender: UIButton) {
        
        APIClient.declineInvitation(with: invitationID)
        
        // Dismisses the popover
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        
        APIClient.acceptInvitation(with: invitationID)
        
        // Dismisses the popover
        self.dismiss(animated: true, completion: nil)
    }
    
}
