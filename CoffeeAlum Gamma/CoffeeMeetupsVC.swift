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

    // MARK: - IBOutlets
    @IBOutlet var mainView: CoffeeMeetupsVCMainView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noInvitationLabel: UILabel!
    @IBOutlet weak var sidebarMenuButton: UIButton!
    
    // MARK: - Variables
    var headerTitleLabel: UILabel?
    var titleHidden = true
    var coffeeSelectedIndex: Int?
    var collectionViewSection: Int?
    var allCoffee = Set<Invitation>()
    var db = FIRDatabase.database().reference()
    var refreshController = UIRefreshControl()
    
    var coffeeRef: FIRDatabaseReference {
        get {
            return db.child("coffees")
        }
    }
    
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

    
    // MARK: - Mandatory Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup sidebar view controller
        self.setupRevealViewController()
        // Setup sidebar button
        sidebarMenuButton.setupSidebarMenuButton(to: self)
        
        // Retreives the invites
        retrieveCoffeeData()
        // Setup refresh controller
        setupRefreshController()
    }

    
    override func viewDidLayoutSubviews() {
        // Using the Pan Gesture Recognizer to reveal the "SWRevealViewController"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Adjusting the revealWidth so that it works fairly with all screen sizes
        self.revealViewController().rearViewRevealWidth = self.view.frame.width / 3.2
    }
    
    
    // Sidebar button which reveals the side bar
    @IBAction func sidebarMenuButtonAction(_ sender: UIButton) {
        
        
    }
    
    fileprivate func setupRefreshController() {
        refreshController.addTarget(self,
                                    action: #selector(refreshStream),
                                    for: .valueChanged)
        collectionView.addSubview(refreshController)
        collectionView.alwaysBounceVertical = true
    }
    
    
    @objc fileprivate func refreshStream() {
        collectionView.reloadData()
        refreshController.endRefreshing()
    }
    
    
    func retrieveCoffeeData() {
        // Allows the collection view to refresh
        self.allCoffee.removeAll()
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let sentInviteCoffeRef = coffeeRef.queryOrdered(byChild: "fromId").queryEqual(toValue: uid)
        let gotInviteCoffeeRef = coffeeRef.queryOrdered(byChild: "toId").queryEqual(toValue: uid)
        let userRef = db.child("users")
        
        // You sent invite; looking for the person to sent it TO
        sentInviteCoffeRef.observe(.value, with: { snapshot in
            for item in snapshot.children {
                
                // NOT DRY
                let coffeeSnap = item as? FIRDataSnapshot
                let coffee = Coffee(snapshot: coffeeSnap!)
                let otherUserRef = userRef.child(coffee.toId)
                
                otherUserRef.observe(.value, with: { (snapshot) in
                    
                    let meetingUser = User(snapshot: snapshot)
    
                    let invitation = Invitation(
                        coffee: coffee,
                        user: meetingUser
                    )
                    
                    self.insertCoffee(with: invitation)
                    
                })
            }
        })
        
        // You got the invite; looking for person I received it FROM
        gotInviteCoffeeRef.observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                
                // NOT DRY
                let coffeeSnap = item as? FIRDataSnapshot
                let coffee = Coffee(snapshot: coffeeSnap!)
                let otherUserRef = userRef.child(coffee.fromId)
                
                otherUserRef.observe(.value, with: { (snapshot) in
                    
                    // NOT DRY
                    let meetingUser = User(snapshot: snapshot)
                    
                    let invitation = Invitation(
                        coffee: coffee,
                        user: meetingUser
                    )
                    
                    self.insertCoffee(with: invitation)
                    
                })
            }
        })

    }
    
    
    fileprivate func insertCoffee(with invitation: Invitation) {
        
        self.allCoffee.insert(invitation)
        self.collectionView.reloadData()
        
        // NOT DRY
        if self.allCoffee.count > 0 {
            self.noInvitationLabel.isHidden = true
        } else {
            self.noInvitationLabel.isHidden = false
        }
        
    }
    
    // TODO: Delete the coffee meetup declined
    func deleteCoffeeMeetupSelected() {
        
        // Check which section the user has selected
        // Remove the coffee based the section selected
        if self.collectionViewSection == 0 {
            self.upcomingCoffee.remove(
                at: self.coffeeSelectedIndex!
            )
        } else if self.collectionViewSection == 1 {
            self.pendingCoffee.remove(
                at: self.coffeeSelectedIndex!
            )
        } else {
            self.rescheduledCoffee.remove(
                at: self.coffeeSelectedIndex!
            )
        }
        
        // Update the collectionView
        self.collectionView.performBatchUpdates({
            
            let indexPaths = [IndexPath(
                row: self.coffeeSelectedIndex!,
                section: self.collectionViewSection!
            )]
            
            self.collectionView.deleteItems(at: indexPaths)
            
        }) { (finished) in
            
            self.retrieveCoffeeData()
            self.collectionView.reloadData()
            
        }
        
    }
    
    func rescheduleCoffeeMeetup() {
        
        
        
    }
    
}

