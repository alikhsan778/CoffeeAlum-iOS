//
//  APIClient.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 5/19/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Firebase

class APIClient {
    
    fileprivate static let uid = FIRAuth.auth()!.currentUser!.uid
    fileprivate static var db = FIRDatabase.database().reference()
    fileprivate static let firebaseAuth = FIRAuth.auth()
    fileprivate static var coffeeReference: FIRDatabaseReference {
        get {
            return db.child("coffees")
        }
    }
    fileprivate static let userReference = db.child("users")
    
    
    // MARK: - Invitation Response
    static func acceptInvitation(with id: String) {
        let invitationReference = coffeeReference.child(id)
        invitationReference.child("accepted").setValue(true)
        
        // This is done to make sure it doesn't end up in the upcoming invitation array when it's being rescheduled
        invitationReference.child("rescheduled").setValue(false)
    }
    
    static func declineInvitation(with id: String, state: InvitationState) {
        
        let invitationReference = coffeeReference.child(id)
        
        switch state {
        case .declined:
            // Delete the value
            invitationReference.removeValue()
        case .rescheduled:
            // Only update the value, doesn't delete in on Firebase
            invitationReference.child("accepted").setValue(false)
        default:
            break
        }
    }
    
    static func rescheduleInvitation(with id: String) {
        let invitationReference = coffeeReference.child(id)
        invitationReference.child("rescheduled").setValue(true)
    }
    
    // MARK: - CoffeeData Manager 
    static func retrieveCoffeeData() {
        
    }
    
    static func getCoffeeInvitation() {
        
    }
    
    static func sendCoffeeInvitation() {
       
        
    }
    
    // MARK: - App Entry And Exit 
    static func signIn(with email: String, password: String, completion: (() -> Void)?) {
        firebaseAuth?.signIn(withEmail: email, password: password,
            completion: { (user, error) in
            if error == nil {
                // Presents the home view controller
                completion?()
            } else {
                
                // Throws error
                // TODO: TODO: Add UIAlert
                /*
                let credentialAlert = UIAlertController(title: "Sign in error", message: "Password or email may be incorrect", preferredStyle: .alert)
                credentialAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(credentialAlert, animated: true, completion: nil)
                */
            }

        })
        
    }
    
    static func signOut() {
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    static func signUp(with email: String, password: String, completion: ((FIRUser) -> Void)?) {
        // TODO: Move this to APIClient
        // Success in signing up, create user in Firebase
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            // There's no error
            if error == nil {
                
                completion?(user!)
                
            } else {
                
            }
        })

    }
    
    // MARK: - Retrieve User Information
    static func retrieveUserInformation() {
        
        
    }
    
}
