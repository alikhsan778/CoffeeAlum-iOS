//
//  ListOfCoffeeMeetupsViewController.swift
//  CoffeeAlum
//
//  Created by Trevin Wisaksana on 12/26/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit
import Firebase

final class CoffeeMeetupsVC: UIViewController, SWRevealViewControllerDelegate, UIPopoverPresentationControllerDelegate, CoffeeMeetupsDelegate {
    
    private enum State {
        case `default`
        case loading
        case refreshData
        case retrieveCoffee
        case removeCoffee
        case rescheduleCoffee
    }
    
    private var state: State = .default {
        didSet {
            didChangeState(state)
        }
    }

    // MARK: - IBOutlets
    @IBOutlet var mainView: CoffeeMeetupsVCMainView!
    @IBOutlet weak var collectionView: CoffeeMeetupsVCCollectionView!
    @IBOutlet weak var noInvitationLabel: UILabel!
    @IBOutlet weak var sidebarMenuButton: UIButton!
    
    // MARK: - Variables
    var headerTitleLabel: UILabel?
    private var titleHidden = true
    public var coffeeSelectedIndex: Int?
    public var collectionViewSection: Int?
    public var allCoffee = Set<Invitation>()
    private var refreshController = UIRefreshControl()
    
    // TODO: Getters and setters change it to fitler coffee
    var pendingCoffee: [Invitation] {
        get {
            return Array(allCoffee).filter {
                !$0.coffee.accepted && !$0.coffee.rescheduled
            }
        }
        
        set {
            let invitationSelected = self.pendingCoffee[coffeeSelectedIndex!]
            allCoffee.remove(invitationSelected)
        }
    }
    
    var upcomingCoffee: [Invitation] {
        get {
            return Array(allCoffee).filter {
                $0.coffee.accepted && !$0.coffee.rescheduled
            }
        }
        
        set {
            let invitationSelected = self.upcomingCoffee[coffeeSelectedIndex!]
            allCoffee.remove(invitationSelected)
        }
    }
    
    var rescheduledCoffee: [Invitation] {
        get {
            return Array(allCoffee).filter {
                $0.coffee.rescheduled && !$0.coffee.accepted
            }
        }
        
        set {
            let invitationSelected = self.rescheduledCoffee[coffeeSelectedIndex!]
            allCoffee.remove(invitationSelected)
        }
    }

    
    private func didChangeState(_ state: State) {
        switch state {
        case .loading:
            retrieveCoffeeData()
            setupRefreshController()
            setupRevealViewController()
            sidebarMenuButton.setupSidebarButtonAction(to: self)
        case .refreshData:
            retrieveCoffeeData()
            collectionView.reloadData()
            refreshController.endRefreshing()
        case .removeCoffee:
            break
        case .rescheduleCoffee:
            break
        default:
            break
        }
    }
    
    // MARK: - Mandatory Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .loading
    }

    override func viewDidLayoutSubviews() {
        // Using the Pan Gesture Recognizer to reveal the "SWRevealViewController"
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        // Adjusting the revealWidth so that it works fairly with all screen sizes
        revealViewController().rearViewRevealWidth = self.view.frame.width / 3.2
    }
    
    private func setupRefreshController() {
        refreshController.addTarget(
            self,
            action: #selector(refreshStream),
            for: .valueChanged
        )
        collectionView.addSubview(refreshController)
        collectionView.alwaysBounceVertical = true
    }
    
    @objc fileprivate func refreshStream() {
        state = .refreshData
    }
    
    func retrieveCoffeeData() {
        // Allows the collection view to refresh
        allCoffee.removeAll()
        
        APIClient.getCoffeeInvitationReceived { [weak self] (invitationReceived) in
            self?.insertCoffee(with: invitationReceived)
        }
        
        APIClient.getCoffeeInvitationSent { [weak self] (invitationSent) in
            self?.insertCoffee(with: invitationSent)
        }
    }
    
    
    fileprivate func insertCoffee(with invitation: Invitation) {
        
        allCoffee.insert(invitation)
        collectionView.reloadData()
        
        // NOT DRY
        if allCoffee.count > 0 {
            noInvitationLabel.isHidden = true
        } else {
            noInvitationLabel.isHidden = false
        }
        
    }
    
    // TODO: Delete the coffee meetup declined
    func deleteCoffeeMeetupSelected() {
        
        // Check which section the user has selected
        // Remove the coffee based the section selected
        if collectionViewSection == 0 {
            upcomingCoffee.remove(at: coffeeSelectedIndex!)
        } else if collectionViewSection == 1 {
            pendingCoffee.remove(at: coffeeSelectedIndex!)
        } else {
            rescheduledCoffee.remove(at: coffeeSelectedIndex!)
        }
        
        // Update the collectionView
        collectionView.performBatchUpdates({
            
            let indexPaths = [IndexPath(
                row: self.coffeeSelectedIndex!,
                section: self.collectionViewSection!
            )]
            
            self.collectionView.deleteItems(at: indexPaths)
            
        }) { (_) in
            self.state = .refreshData
        }
        
    }
    
}

