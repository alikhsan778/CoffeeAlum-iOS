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

final class InvitationVC: UIViewController {
    
    private enum State {
        case `default`
        case loading
        case acceptInvitation
        case rescheduleInvitation
        case declineInvitation(using: UIButton)
        case failedToReschedule(error: Error)
        case popover
    }
    
    private var state: State = .default {
        didSet {
            didChange(state)
        }
    }
    
    private enum `Error` {
        case rescheduleMessageIsEmpty
    }
    
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
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        
        state = .loading
        
        // Assigning the invitation ID
        invitationID = invitation?.coffee.id
        
        if invitation.coffee.accepted {
            declineButtonOutlet.setTitle(
                "Reschedule",
                for: .normal
            )
        }
        
        // TODO: DRY, this can be added in an extension
        let profileURL = invitation.user.portrait
        let url = URL(string: profileURL)
        profilePicture.sd_setImage(with: url)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        state = .loading
        setupUIElements()
        profilePicture.circularize()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let window = UIApplication.shared.keyWindow?.frame else {
            return
        }
        
        // TODO: Move this to viewDidAppear
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
    
    private func didChange(_ state: State) {
        switch state {
        case .loading:
            break
        case .acceptInvitation:
            acceptInvitation()
        case .declineInvitation(let button):
            declineInvitation(from: button)
        case .rescheduleInvitation:
            sendRescheduleMessage()
        default:
            break
        }
    }
    
    
    func setupUIElements() {
        personInvitingLabel.text = invitation?.user.name
        dateAndTimeLabel.text = invitation?.coffee.date
        placeLabel.text = invitation?.coffee.location
        
        setupRescheduleView()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    
    // MARK: - IBActions
    @IBAction func declineButtonAction(_ sender: UIButton) {
        state = .declineInvitation(using: sender)
    }
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        state = .acceptInvitation
    }
    
    @IBAction func sendRescheduleMessageAction(_ sender: UIButton) {
        state = .rescheduleInvitation
    }
    
    @IBAction func cancelRescheduleButtonAction(_ sender: UIButton) {
        dismissPopover(view: rescheduleView)
    }
    
    // MARK: - Methods
    func setupRescheduleView() {
        
        rescheduleView.isHidden = true
        
        rescheduleView.frame.size = CGSize(
            width: self.view.frame.width,
            height: self.view.frame.height
        )
        rescheduleView.center = self.view.center
        self.view.addSubview(view)
    
    }
    
    fileprivate func acceptInvitation() {
        // Accepts invitation
        APIClient.acceptInvitation(with: invitationID)
        // Removes the item from the cell
        delegate?.deleteCoffeeMeetupSelected()
        // Dismisses the popover
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func declineInvitation(from button: UIButton) {
        let declineButtonTitle = button.titleLabel?.text
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
    
    fileprivate func sendRescheduleMessage() {
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
