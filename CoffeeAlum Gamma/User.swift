////
////  User.swift
////  CoffeeAlum Gamma
////
////  Created by Nabil K on 2017-01-09.
////  Copyright © 2017 Trevin Wisaksana. All rights reserved.
////
//
import Foundation
import UIKit
import Firebase

class User: Hashable {
    
    var name: String
    var email: String = ""
    var account: AccountType = .alum
    var bio: String = ""
    var employer: String = ""
    var role: String = ""
    var education: String = ""
    var location: String = ""
    var linkedIn: String = ""
    var website: String = ""
    var coffeeIds: [String] = []
    var coffees: [Coffee] = []
    var portrait: String = ""
    var uid: String = ""
    var ref: FIRDatabaseReference?
    var db = FIRDatabase.database().reference().child("users")
    
    var hashValue: Int {
        return self.uid.hashValue
    }
    
    init(name:String, account:AccountType, education: String, location: String){
        self.name = name
        self.account = account
        self.education = education
        self.location = location
    }
    
    
    init(snapshot: FIRDataSnapshot) {
        
        uid = snapshot.key
        
        let snapshotValue = snapshot.value as! [String : AnyObject]
        
        name = snapshotValue["name"] as? String ?? ""
        
        guard let accountString = snapshotValue["account"] as? String else {
            return
        }
        
        self.account = AccountType(rawValue: accountString)!
        
        
        bio = snapshotValue["bio"] as? String ?? ""
        education = snapshotValue["education"] as? String ?? ""
        employer = snapshotValue["employer"] as? String ?? ""
        role = snapshotValue["role"] as? String ?? ""
        linkedIn = snapshotValue["linkedIn"] as? String ?? ""
        website = snapshotValue["website"] as? String ?? ""
        
        // Protects from crashing
        guard let locationData = snapshotValue["location"],
              let coffeeIdsData = snapshotValue["coffees"],
              let portraitsData = snapshotValue["portrait"],
              let emailData = snapshotValue["email"],
              let uidata = snapshotValue["uid"]
              else {
                return
        }
        
        location = locationData as! String
        portrait = portraitsData as! String
        email = emailData as! String
        uid = uidata as! String
        
        for item in coffeeIdsData.children {
            let value = item as! FIRDataSnapshot
            let thisCoffee = Coffee(snapshot: value)
            coffees.append(thisCoffee)
        }
    
        
        uid = snapshot.key
        ref = snapshot.ref
    }
    
    func toAnyObject() -> NSDictionary {
        let coffeeIdDict : [String:String] = [:]
        // TODO: Eliminate the redundancy below time permitting
        // Each Id is its own key for ease of access
        // coffeeIds.map({coffeeIdDict[$0] = $0})
        
        return [
            "name": name,
            "account": account.rawValue,
            "role": role,
            "employer" : employer,
            "education": education,
            "location": location,
            "coffeeIds": coffeeIdDict,
            "portrait": portrait,
            "email": email,
            "uid": uid
        ]
    }
    
    func save() {
        let id = FIRAuth.auth()!.currentUser!.uid
        if self.ref == nil{
            self.ref = db.child(id)
        }
        self.ref!.setValue(self.toAnyObject())
    }
    
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
    
}

