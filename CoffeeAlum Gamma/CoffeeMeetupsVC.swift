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

    // TODO: These vars are too heavy, think of more elegant solution for next version
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noInvitationLabel: UILabel!
    var headerTitleLabel: UILabel?
    var titleHidden = true
    var coffeeSelectedIndex: Int?
    var collectionViewSection: Int?
    
    var db = FIRDatabase.database().reference()
    
    var coffeeRef: FIRDatabaseReference {
        get {
            return db.child("coffees")
        }
    }
    
    var sentInviteCoffee: [(coffee: Coffee, user: User)] = []
    
    var gotInviteCoffee: [(coffee: Coffee, user: User)] = []
    
    var allCoffee: [(coffee: Coffee, user: User)] {
        get {
            return sentInviteCoffee + gotInviteCoffee
        }
    }
    
    var pendingCoffee: [(coffee: Coffee, user: User)] {
        get {
            return allCoffee.filter {
                !$0.coffee.accepted
            }
        }
        
        set {
            
        }
    }
    
    var upComingCoffee: [(coffee: Coffee, user: User)] {
        get {
            return allCoffee.filter {
                !$0.coffee.accepted
            }
            
        }
        
        set {
            
        }
    }
    
    var testData = ["Test"]
    // TODO: Create a button that switches the data based on what the user wants
    var data:[(Coffee, User)]?
    // MARK: - User Interaction Properties
    var tapGesture = UITapGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()
    
    // Sidebar button which reveals the side bar
    @IBAction func sidebarMenuButtonAction(_ sender: UIButton) {
        // Connects to the revealToggle method in the SWRevealViewController custom code
        sender.addTarget(
            self.revealViewController(),
            action: #selector(SWRevealViewController.revealToggle(_:)),
            for: .touchUpInside
        )
    }
    
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
    
    
    func retrieveCoffeeData() {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let sentInviteCoffeRef = coffeeRef.queryOrdered(byChild: "fromId").queryEqual(toValue: uid)
        let gotInviteCoffeeRef = coffeeRef.queryOrdered(byChild: "toId").queryEqual(toValue: uid)
        let userRef = db.child("users")
        
        // You sent invite; looking for the person to sent it TO
        sentInviteCoffeRef.observe(.value, with: { snapshot in
            for item in snapshot.children{
                let coffeeSnap = item as? FIRDataSnapshot
                let coffee = Coffee(snapshot: coffeeSnap!)
                let otherUserRef = userRef.child(coffee.toId)
                
                otherUserRef.observe(.value, with: { (snapshot) in
                    
                    let meetingUser = User(snapshot: snapshot)
                    
                    self.sentInviteCoffee.append((coffee, meetingUser))
                    self.collectionView.reloadData()
                    
                    // TODO: DRY
                    if self.sentInviteCoffee.count > 0 {
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
                
                let coffeeSnap = item as? FIRDataSnapshot
                let coffee = Coffee(snapshot: coffeeSnap!)
                let otherUserRef = userRef.child(coffee.fromId)
                
                otherUserRef.observe(.value, with: { (snapshot) in
                    
                    let meetingUser = User(snapshot: snapshot)
                    self.sentInviteCoffee.append((coffee, meetingUser))
                    self.collectionView.reloadData()
                    
                    if self.sentInviteCoffee.count > 0 {
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
        
        if collectionViewSection == 0 {
            print(upComingCoffee.count)
            upComingCoffee.remove(at: coffeeSelectedIndex!)
            print(upComingCoffee.count)
        } else {
            print(pendingCoffee.count)
            pendingCoffee.remove(at: coffeeSelectedIndex!)
            print(pendingCoffee.count)
        }
        
        self.collectionView.reloadData()
        
    }
    
}

