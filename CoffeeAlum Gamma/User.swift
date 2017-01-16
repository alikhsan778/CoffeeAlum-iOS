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
    var name:String
    var account: AccountType
    var employer: String = ""
    var role: String = ""
    var education: String = ""
    var location: String = ""
    var coffees: [Coffee] = []
    var portrait: String = ""
    var uid: String = ""
    var ref: FIRDatabaseReference?
    
    var hashValue: Int {
        return self.uid.hashValue
    }
    
    init(name:String, account:AccountType, education: String, location: String){
        self.name = name
        self.account = account
        self.education = education
        self.location = location
    }
    
    
    init(snapshot: FIRDataSnapshot){
        uid = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        
        let accountBool = snapshotValue["account"] as? Bool ?? false
        
        if accountBool{
            self.account = .alum
        }
            
        else{self.account = .student}
        
        education = snapshotValue["education"] as? String ?? ""
        employer = snapshotValue["employer"] as? String ?? ""
        role = snapshotValue["role"] as? String ?? ""
        
        
        if let locationData = snapshotValue["location"]{
            location = locationData as! String
        }
        
        if let coffeeIdsData = snapshotValue["coffees"] {
            for item in coffeeIdsData.children{
                let value = item as! FIRDataSnapshot
                let thisCoffee = Coffee(snapshot: value)
                coffees.append(thisCoffee)
            }
        }
        
        if let portraitsData = snapshotValue["portrait"]{
            portrait = portraitsData as! String
        }
//        
//        if let emailData = snapshotValue["email"]{
//            email = emailData as! String
//        }
        
        if let uidata = snapshotValue["uid"]{
            uid = uidata as! String
        }
        
        uid = snapshot.key
        ref = snapshot.ref
    }
    
    func toAnyObject() -> NSDictionary{
        
        var accountBool = self.account == .alum

        
        
        return [
            "name": name,
            "account": accountBool,
            "employer" : employer,
            "education": education,
            "location": location,
            //"coffeeIds": coffeeIds,
            "portrait": portrait,
            "uid": uid
        ]
    }
    
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
    
}



enum AccountType: String {
    case student = "student"
    case alum = "alumn"
    case admin = "admin"
    case mentor = "mentor"
}
