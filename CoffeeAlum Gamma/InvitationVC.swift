//
//  InvitationViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/16/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

protocol CoffeeMeetupsDelegate: class {
    func deleteCoffeeMeetupSelected()
}

final class InvitationVC: UIViewController {
    
    // MARK: - State Machine
    private enum State {
        case `default`
        case loading
        case viewDidLayoutSubviews
        case viewDidAppear
        case acceptInvitation
        case rescheduleInvitation
        case sendRescheduleMessage
        case declineInvitation(using: UIButton)
        case failedToReschedule(as: Error)
        case cancelReschedule
        case popover
    }
    
    private var state: State = .default {
        didSet {
            didChange(state)
        }
    }
    
    private func didChange(_ state: State) {
        switch state {
        case .loading:
            break
        case .viewDidAppear:
            addRescheduleView()
        case .acceptInvitation:
            acceptInvitation()
        case .declineInvitation(let button):
            declineInvitation(from: button)
        case .rescheduleInvitation:
            displayRescheduleView()
        case .sendRescheduleMessage:
            sendRescheduleMessage()
        case .cancelReschedule:
            dismissRescheduleView()
        case .viewDidLayoutSubviews:
            // TODO: Remove the Bang Operator
            mainView.prepareLabelTexts(with: invitation!)
        default:
            break
        }
    }
    
    private enum `Error` {
        case rescheduleMessageIsEmpty
    }
    
    // MARK: - IBOutlets
    @IBOutlet var mainView: InvitationVCMainView!
    
    weak var delegate: CoffeeMeetupsDelegate?
    var invitation: Invitation?
    var invitationID: String?
    public var apiClient = APIClient()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .loading
        
        // Assigning the invitation ID
        invitationID = invitation?.coffee.id
        
        guard let invitationIsAccepted = invitation?.coffee.accepted else {
            return
        }
        
        if invitationIsAccepted {
            mainView.declineButtonOutlet.setTitle(
                "Reschedule",
                for: .normal
            )
        }
        
        // TODO: DRY, this can be added in an extension
        guard let profileURL = invitation?.user.portrait else {
            return
        }
        
        let url = URL(string: profileURL)
        mainView.profilePicture.sd_setImage(with: url)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        state = .viewDidLayoutSubviews
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        state = .viewDidAppear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let window = UIApplication.shared.keyWindow?.frame else {
            return
        }
        
        // TODO: Move this to viewDidAppear
        self.preferredContentSize = CGSize(
            width: window.width * 0.9,
            height: window.height * 0.27
        )
        
        self.popoverPresentationController?.sourceRect = CGRect(
            x: window.midX,
            y: window.midY * 1.8,
            width: 0,
            height: 0
        )
        
        self.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
    }
    
    // MARK: - IBActions
    @IBAction func declineButtonAction(_ sender: UIButton) {
        state = .declineInvitation(using: sender)
    }
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        state = .acceptInvitation
    }
    
    @IBAction func sendRescheduleMessageAction(_ sender: UIButton) {
        state = .sendRescheduleMessage
    }
    
    @IBAction func cancelRescheduleButtonAction(_ sender: UIButton) {
        state = .cancelReschedule
    }
    
    // MARK: - Methods
    func addRescheduleView() {
        mainView.rescheduleView.isHidden = true
        mainView.rescheduleView.frame.size = CGSize(
            width: self.view.frame.width,
            height: self.view.frame.height
        )
        mainView.rescheduleView.center = self.view.center
        self.view.addSubview(mainView.rescheduleView)
    }
    
    private func acceptInvitation() {
        
        guard let invitationID = self.invitationID else {
            return
        }
        
        // Accepts invitation
        apiClient.acceptInvitation(with: invitationID)
        // Removes the item from the cell
        delegate?.deleteCoffeeMeetupSelected()
        // Dismisses the popover
        self.dismiss(animated: true, completion: nil)
    }
    
    private func declineInvitation(from button: UIButton) {
        let declineButtonTitle = button.titleLabel?.text
        
        guard let invitationID = self.invitationID else {
            return
        }
        
        if declineButtonTitle == "Decline" {
            // Sends a decline request
            apiClient.declineInvitation(
                with: invitationID,
                state: .declined
            )
            // Removes the item from the cell
            delegate?.deleteCoffeeMeetupSelected()
            // Dismisses the popover
            self.dismiss(animated: true, completion: nil)
        } else if declineButtonTitle == "Reschedule" {
            state = .rescheduleInvitation
        }
    }
    
    private func sendRescheduleMessage() {
    
        guard let rescheduleMessage = mainView.rescheduleTextView.text else {
            state = .failedToReschedule(as: .rescheduleMessageIsEmpty)
            return
        }
        
        guard let invitationID = self.invitationID else {
            return
        }
        
        // Sends a reschedule request
        apiClient.rescheduleInvitation(with: invitationID,
                                       message: rescheduleMessage)
        // Must decline invitation as well
        apiClient.declineInvitation(with: invitationID,
                                    state: .rescheduled)
        // Removes the item from the cell
        delegate?.deleteCoffeeMeetupSelected()
        dismissRescheduleView()
        // Dismisses the popover
        self.dismiss(animated: true, completion: nil)
    }
    
    private func displayRescheduleView() {
        
        guard let rescheduleView = mainView.rescheduleView else {
            return
        }
        
        rescheduleView.isHidden = false
        
        rescheduleView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        // Bringing the popover view to front
        self.view.bringSubview(toFront: rescheduleView)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: { () -> Void in
            rescheduleView.transform = CGAffineTransform.identity
            rescheduleView.alpha = 1
        }, completion: nil)
    }
    
    // Method to dimiss the popover
    func dismissRescheduleView() {
        // Animation to dismiss the popover
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: { () -> Void in
            
            // Animation to scale before disappearing
            self.mainView.rescheduleView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.mainView.rescheduleView.alpha = 0
        
        }, completion: { (success: Bool) in
            self.mainView.rescheduleView.isHidden = true
        })
    }
}
