//
//  APIClient.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 5/19/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Firebase

class APIClient {
    
    let uid = FIRAuth.auth()!.currentUser!.uid
    var db = FIRDatabase.database().reference()
    
    
    // MARK: - Invitation Response
    static func acceptInvitation(with id: String) {
        
    }
    
    static func declineInvitation(with id: String) {
        
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
        FIRAuth.auth()?.signIn(withEmail: email, password: password,
            completion: { (user, error) in
            if error == nil {
                // Presents the home view controller
                completion?()
            } else {
                // Throws error
                // TODO: UIAlert
            }

        })
        
    }
    
    static func signOut() {
        // Firebase auth
        let firebaseAuth = FIRAuth.auth()
        
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    static func signUp() {
        
    }
    
    // MARK: - Retrieve User Information 
    static func retrieveUserInformation() {
        
    }
    
}
