//
//  ListOfCoffeeMeetupsViewController.swift
//  CoffeeAlum
//
//  Created by Trevin Wisaksana on 12/26/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit
import Firebase

class CoffeeMeetupsVC: UIViewController, SWRevealViewControllerDelegate, UIPopoverPresentationControllerDelegate, CoffeeMeetupsDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noInvitationLabel: UILabel!
    
    // MARK: - Variables
    var headerTitleLabel: UILabel?
    var titleHidden = true
    var coffeeSelectedIndex: Int?
    var collectionViewSection: Int?
    var allCoffee = Set<Invitation>()
    var db = FIRDatabase.database().reference()
    
    var coffeeRef: FIRDatabaseReference {
        get {
            return db.child("coffees")
        }
    }
    
    var pendingCoffee: [Invitation] {
        get {
            return Array(allCoffee).filter {
                !$0.coffee.accepted
            }
        }
        set {}
    }
    
    var upcomingCoffee: [Invitation] {
        get {
            return Array(allCoffee).filter {
                $0.coffee.accepted
            }
        }
        set {}
    }
    
    var testData = ["Test"]
    // TODO: Create a button that switches the data based on what the user wants
    var data:[(Coffee, User)]?
    // MARK: - User Interaction Properties
    var tapGesture = UITapGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()
    
    // MARK: - Mandatory Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retreives the invites
        retrieveCoffeeData()
    }

    
    override func viewDidLayoutSubviews() {
        // Using the Pan Gesture Recognizer to reveal the "SWRevealViewController"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Adjusting the revealWidth so that it works fairly with all screen sizes
        self.revealViewController().rearViewRevealWidth = self.view.frame.width / 3.2
    }
    
    
    // Sidebar button which reveals the side bar
    @IBAction func sidebarMenuButtonAction(_ sender: UIButton) {
        // Connects to the revealToggle method in the SWRevealViewController custom code
        sender.addTarget(
            self.revealViewController(),
            action: #selector(SWRevealViewController.revealToggle(_:)),
            for: .touchUpInside
        )
    }
    
    
    func retrieveCoffeeData() {
        
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
                    
                    // CHANGE THE BANG OPERATOR
                    self.allCoffee.insert(invitation!)
                    self.collectionView.reloadData()
                    
                    // TODO: DRY
                    if self.allCoffee.count > 0 {
                        self.noInvitationLabel.isHidden = true
                    } else {
                        self.noInvitationLabel.isHidden = false
                    }
                    
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
                    
                    // CHANGE THE BANG OPERATOR
                    self.allCoffee.insert(invitation!)
                    self.collectionView.reloadData()
                    
                    // NOT DRY
                    if self.allCoffee.count > 0 {
                        self.noInvitationLabel.isHidden = true
                    } else {
                        self.noInvitationLabel.isHidden = false
                    }
                    
                })
            }
        })

    }
    
    // TODO: Delete the coffee meetup declined
    func deleteCoffeeMeetup() {
        
        if self.collectionViewSection == 0 {
            self.upcomingCoffee.remove(at: self.coffeeSelectedIndex!)
        } else {
            self.pendingCoffee.remove(at: self.coffeeSelectedIndex!)
        }
 
        self.collectionView.performBatchUpdates({
            
            let indexPaths = [IndexPath(
                row: self.coffeeSelectedIndex!,
                section: self.collectionViewSection!
            )]
            
            self.collectionView.deleteItems(at: indexPaths)
            
        }) { (finished) in
            
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            
        }
        
    }
    
}

