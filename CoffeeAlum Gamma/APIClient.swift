//
//  APIClient.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 5/19/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Firebase
import FirebaseStorage
import GoogleSignIn

enum InvitationState {
    case `default`, declined, rescheduled
}

// TODO: Potentially make the APIClient not Firebase specific
final class APIClient {
    
    fileprivate lazy var uid = FIRAuth.auth()!.currentUser!.uid
    fileprivate var db = FIRDatabase.database().reference()
    fileprivate let firebaseAuth = FIRAuth.auth()
    fileprivate var coffeeReference: FIRDatabaseReference {
        get {
            return db.child("coffees")
        }
    }
    fileprivate let userReference = FIRDatabase.database().reference().child("users")
    fileprivate let storageReference = FIRStorage.storage().reference()
    
    
    // MARK: - Invitation Response
    public func acceptInvitation(with id: String) {
        let invitationReference = coffeeReference.child(id)
        invitationReference.child("accepted").setValue(true)
        
        // This is done to make sure it doesn't end up in the upcoming invitation array when it's being rescheduled
        invitationReference.child("rescheduled").setValue(false)
    }
    
    public func declineInvitation(with id: String, state: InvitationState) {
        
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
    
    public func rescheduleInvitation(with id: String, message: String) {
        let invitationReference = coffeeReference.child(id)
        invitationReference.child("rescheduled").setValue(true)
        invitationReference.child("message").setValue(message)
    }
    
    // MARK: - CoffeeData Manager 
    public func retrieveCoffeeInvitationData() {
        
    }
    
    public func getCoffeeInvitationSent(completion: ((Invitation) -> Void)?) {
        let invitationSent = coffeeReference.queryOrdered(byChild: "fromId").queryEqual(toValue: uid)
        // You sent invite; looking for the person to sent it TO
        invitationSent.observe(.value, with: { snapshot in
            for item in snapshot.children {
                
                // NOT DRY
                let coffeeSnap = item as? FIRDataSnapshot
                let coffee = Coffee(snapshot: coffeeSnap!)
                let otherUserRef = self.userReference.child(coffee.toId)
                
                otherUserRef.observe(.value, with: { (snapshot) in
                    
                    let meetingUser = User(snapshot: snapshot)
                    
                    let invitation = Invitation(
                        coffee: coffee,
                        user: meetingUser
                    )
                    
                    completion?(invitation)
                    
                })
            }
        })
    }
    
    public func getCoffeeInvitationReceived(completion: ((Invitation) -> Void)?) {
        
        let invitationReceived = coffeeReference.queryOrdered(byChild: "toId").queryEqual(toValue: uid)
        // You got the invite; looking for person I received it FROM
        invitationReceived.observe(.value, with: { (snapshot) in
            for item in snapshot.children {
                
                // NOT DRY
                let coffeeSnap = item as? FIRDataSnapshot
                let coffee = Coffee(snapshot: coffeeSnap!)
                let otherUserRef = self.userReference.child(coffee.fromId)
                
                otherUserRef.observe(.value, with: { (snapshot) in
                    
                    // NOT DRY
                    let meetingUser = User(snapshot: snapshot)
                    
                    let invitation = Invitation(
                        coffee: coffee,
                        user: meetingUser
                    )
                    
                    completion?(invitation)
                    
                })
            }
        })

    }
    
    public func sendCoffeeInvitation() {
       
        
    }
    
    // MARK: - App Entry And Exit 
    public func signIn(with email: String, password: String, completion: ((Error?) -> Void)?) {
        firebaseAuth?.signIn(withEmail: email, password: password,
            completion: { (user, error) in
            completion?(error)
        })
    }
    
    public func signOut() {
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    public func signUp(with email: String, password: String, completion: ((Error?) -> Void)?) {
        // TODO: Check if this is an asynchronous call
        // Success in signing up, create user in Firebase
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            // There's no error
            if error == nil {
                
                guard let user = user else {
                    return
                }
                
                let userReference = self.db.child("users").child(user.uid)
                
                // Create Firebase path for this user and save email
                let emailDictionary = ["email": "\(email)"]
                
                // BUG: Format of the completion block must be correct
                // because there is a bug in Firebase
                userReference.setValue(emailDictionary) { (error, _) in
                    completion?(nil)
                }
            } else {
                // Passes the error
                completion?(error)
            }
        })

    }
    
    public func signInWithGoogleAccount(completion: (() -> Void)?) {
        GIDSignIn.sharedInstance().signIn()
        completion?()
    }
    
    public func googleSignOut() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    
    // MARK: - Retrieve User Information
    public func retrieveCurrentUserInformation(completion: ((User) -> Void)?) {
        userReference.child(uid).observe(.value, with: { (snapshot) in
            
            let user = User(snapshot: snapshot)

            completion?(user)
        })
    }
    
    public func downloadAllUserData(completion: (([User]) -> Void)?) {
        
        var filter = Set<User>()
    
        db.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let user = User(snapshot: snapshot)
            
            filter.insert(user)
            let filteredListOfUsers = Array(filter)
            
            completion?(filteredListOfUsers)
        })
    }
    
    // MARK: - Update User Information
    public func save(_ user: User, completion: ((Error?) -> Void)?) {
        
        let toJSON = [
            "name": user.name,
            "account": user.account.rawValue,
            "role": user.role,
            "employer" : user.employer,
            "education": user.education,
            "location": user.location,
            "portrait": user.portrait,
            "email": user.email,
            "uid": user.uid,
            "linkedIn": user.linkedIn,
            "website": user.website,
            "bio": user.bio,
            "searchName": user.name.lowercased()
        ]
        
        userReference.child(uid).setValue(toJSON) { (error, _) in
            completion?(error)
        }
    }
    
    
    public func saveUserProfilePicture(with image: UIImage) {
        
        guard let dataToUpload = UIImagePNGRepresentation(image) else {
            return
        }
        
        let profileImageReference = storageReference.child("profileImage.png")
    
        profileImageReference.put(dataToUpload, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            let downloadURL = metadata?.downloadURL()?.absoluteString
            // TODO: Update the user profile link
            self.userReference.child(self.uid).child("portrait").setValue(downloadURL)
            
        }
    }
}
