//
//  APIClient.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 5/19/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Firebase

// TIP: Use the delegates to access these network calls
fileprivate class APIClient: InvitationResponseDelegate, CoffeeDataManagerDelegate, AppEntryAndExitDelegate, RetrieveUserInformationDelegate {
    
    // MARK: - Invitation Response Delegate
    func acceptInvitation() {
        
    }
    
    func declineInvitation() {
        
    }
    
    // MARK: - CoffeeData Manager Delegate
    func retrieveCoffeeData() {
        
    }
    
    func getCoffeeInvitation() {
        
    }
    
    func sendCoffeeInvitation() {
        
    }
    
    // MARK: - App Entry And Exit Delegate
    func signIn() {
        
    }
    
    func signOut() {
        
    }
    
    func signUp() {
        
    }
    
    // MARK: - Retrieve User Information Delegate
    func retrieveUserInformation() {
        
    }
    
}


protocol InvitationResponseDelegate {
    func acceptInvitation()
    func declineInvitation()
}

protocol CoffeeDataManagerDelegate {
    func retrieveCoffeeData()
    func getCoffeeInvitation()
    func sendCoffeeInvitation()
}

protocol AppEntryAndExitDelegate {
    func signIn()
    func signOut()
    func signUp()
}

protocol RetrieveUserInformationDelegate {
    func retrieveUserInformation()
}

