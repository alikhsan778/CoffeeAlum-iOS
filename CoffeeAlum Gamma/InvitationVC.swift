//
//  InvitationViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/16/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

protocol CoffeeMeetupsDelegate: class {
    func deleteCoffeeMeetup()
    func refreshCollectionView()
}


class InvitationVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var personInvitingLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    weak var delegate: CoffeeMeetupsDelegate?
    var invitation: (coffee: Coffee, user: User)!
    var invitationID: String!
    
    override func viewDidLoad() {
        
        setupUIElements()
        // Assigning the invitation ID
        invitationID = invitation?.coffee.id
        
    }
    
    func setupUIElements() {
        personInvitingLabel.text = invitation?.user.name
        dateAndTimeLabel.text = invitation?.coffee.date
        placeLabel.text = invitation?.coffee.location
    }
    
    // MARK: - IBActions
    @IBAction func declineButtonAction(_ sender: UIButton) {
        
        // Sends a decline request
        APIClient.declineInvitation(with: invitationID)
        
        // Removes the item from the cell
        delegate?.deleteCoffeeMeetup()
        
        // Refreshes the collectionView
        delegate?.refreshCollectionView()
        
        // Dismisses the popover
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        
        APIClient.acceptInvitation(with: invitationID)
        
        delegate?.refreshCollectionView()
        
        // Dismisses the popover
        self.dismiss(animated: true, completion: nil)
    }
    
}
