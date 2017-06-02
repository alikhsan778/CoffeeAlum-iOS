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
    @IBOutlet var rescheduleView: UIView!
    @IBOutlet weak var rescheduleTextView: UITextView!
    
    
    weak var delegate: CoffeeMeetupsDelegate?
    var invitation: Invitation!
    var invitationID: String!
    var invitationState: InvitationState!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
    
        // Assigning the invitation ID
        invitationID = invitation?.coffee.id
        
        if invitation.coffee.accepted == true {
            declineButtonOutlet.setTitle("Reschedule", for: .normal)
            invitationState = .rescheduled
        }
        
        
        // TODO: DRY, this can be added in an extension
        let profileURL = invitation.user.portrait
        let url = URL(string: profileURL)
        profilePicture.sd_setImage(with: url)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupUIElements()
        profilePicture.circularize()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let window = UIApplication.shared.keyWindow?.frame else {
            return
        }
        
        self.preferredContentSize = CGSize(
            width: window.width * 0.9,
            height: window.height * 0.35
        )
        
        self.popoverPresentationController?.sourceRect = CGRect(
            x: window.midX,
            y: window.midY * 1.8,
            width: 0,
            height: 0
        )
        
        self.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
    }
    
    func setupUIElements() {
        personInvitingLabel.text = invitation?.user.name
        dateAndTimeLabel.text = invitation?.coffee.date
        placeLabel.text = invitation?.coffee.location
        
        setupRescheduleView(view: rescheduleView)
    }
    
    override func viewDidLayoutSubviews() {
        
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
            
            // Dismisses the popover
            self.dismiss(animated: true, completion: nil)
            
        } else if declineButtonTitle == "Reschedule" {
            
            // TODO: Display the reschedule message
            setupPopover(view: rescheduleView)
            
        }
    
    }
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        
        // Accepts invitation
        APIClient.acceptInvitation(with: invitationID)
        
        // Removes the item from the cell
        delegate?.deleteCoffeeMeetupSelected()
        
        // Dismisses the popover
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sendRescheduleMessageAction(_ sender: UIButton) {
        
        guard let rescheduleMessage = rescheduleTextView.text else {
            // TODO: Throw an error
            return
        }
        
        // Sends a reschedule request
        APIClient.rescheduleInvitation(
            with: invitationID,
            message: rescheduleMessage
        )
        // Must decline invitation as well
        APIClient.declineInvitation(
            with: invitationID,
            state: .rescheduled
        )
        
        // Removes the item from the cell
        delegate?.deleteCoffeeMeetupSelected()
        
        dismissPopover(view: rescheduleView)
        
        // Dismisses the popover
        self.dismiss(animated: true, completion: nil)

    }
    
    
    @IBAction func cancelRescheduleButtonAction(_ sender: UIButton) {
        
        dismissPopover(view: rescheduleView)
        
    }
    
    
    // MARK: - Methods
    func setupRescheduleView(view: UIView) {
        
        view.isHidden = true
        
        view.frame.size = CGSize(
            width: self.view.frame.width,
            height: self.view.frame.height
        )
        view.center = self.view.center
        self.view!.addSubview(view)
    
    }
    
    
    func setupPopover(view: UIView) {
        
        view.isHidden = false
        
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        // Bringing the popover view to front
        self.view!.bringSubview(toFront: view)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: { () -> Void in
            
            view.transform = CGAffineTransform.identity
            view.alpha = 1
            
        }, completion: nil)
        
    }
    
    // Method to dimiss the popover
    func dismissPopover(view: UIView) {
        
        // Animation to dismiss the popover
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {() -> Void in
            
            // Animation to scale before disappearing
            view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            view.alpha = 0
        
        }, completion: { (success: Bool) in
            view.isHidden = true
        })
        
    }

    
}
