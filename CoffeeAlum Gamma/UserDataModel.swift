//
//  UserData.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/27/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import Foundation

// Data model for each user
class UserDataModel {
    
    // User name
    var name: String?
    // User email
    var email: String?
    // Student or alum of type enum
    var studentOrAlum: StudentOrAlum?
    // User short bio
    var userShortBio: String?
    // User education background
    var educationalBackground: String?
    // User location
    var userLocation: String?
    // User job occupancy
    var jobOccupancy: String?
    // Group the user is currently a part of
    var memberOfGroup: [String?]
    // User profile picture
    var profilePicture: String?
    
    // Initializing all the variables
    init(name: String?, email: String?, studentOrAlum: StudentOrAlum?, educationalBackground: String?, userLocation: String?, userShortBio: String?, memberOfGroup: [String?], profilePicture: String?) {
        self.name = name
        self.email = email
        self.studentOrAlum = studentOrAlum
        self.educationalBackground = educationalBackground
        self.userLocation = userLocation
        self.userShortBio = userShortBio
        self.memberOfGroup = memberOfGroup
        self.profilePicture = profilePicture
    }
    
}
