//
//  InvitationViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/16/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

protocol CoffeeMeetupsDelegate: class {
    func deleteCoffeeMeetupSelected()
}

enum InvitationState: String {
    case pending = "Pending"
    case accepted = "Accept"
    case rescheduled = "Reschedule"
    case declined = "Decline"
}


final class InvitationVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var personInvitingLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var declineButtonOutlet: UIButton!
    
    weak var delegate: CoffeeMeetupsDelegate?
    var invitation: Invitation!
    var invitationID: String!
    var invitationState: InvitationState!
    
    override func viewDidLoad() {
        
        setupUIElements()
        // Assigning the invitation ID
        invitationID = invitation?.coffee.id
        
        if invitation.coffee.accepted == true {
            declineButtonOutlet.setTitle("Reschedule", for: .normal)
            invitationState = .rescheduled
        }
    }
    
    func setupUIElements() {
        personInvitingLabel.text = invitation?.user.name
        dateAndTimeLabel.text = invitation?.coffee.date
        placeLabel.text = invitation?.coffee.location
    }
    
    
    // MARK: - IBActions
    @IBAction func declineButtonAction(_ sender: UIButton) {
        
        let declineButtonTitle = sender.titleLabel?.text
        
        if declineButtonTitle == "Decline" {
            
            // Sends a decline request
            APIClient.declineInvitation(
                with: invitationID,
                state: .declined
            )
            
            // Removes the item from the cell
            delegate?.deleteCoffeeMeetupSelected()
            
        } else if declineButtonTitle == "Reschedule" {
            
            // Sends a reschedule request
            APIClient.rescheduleInvitation(with: invitationID)
            // Must decline invitation as well
            APIClient.declineInvitation(
                with: invitationID,
                state: .rescheduled
            )
            
            // Removes the item from the cell
            delegate?.deleteCoffeeMeetupSelected()
            
        }
    
        // Dismisses the popover
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        
        // Accepts invitation
        APIClient.acceptInvitation(with: invitationID)
        
        // Removes the item from the cell
        delegate?.deleteCoffeeMeetupSelected()
        
        // Dismisses the popover
        self.dismiss(animated: true, completion: nil)
    }
    
}
