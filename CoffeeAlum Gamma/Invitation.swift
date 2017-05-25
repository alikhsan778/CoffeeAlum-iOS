//
//  Invitation.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 5/23/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

struct Invitation: Hashable, Equatable {
    
    var coffee: Coffee
    var user: User
    
    init?(coffee: Coffee, user: User) {
        self.coffee = coffee
        self.user = user
    }
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func ==(lhs: Invitation, rhs: Invitation) -> Bool {
        if lhs.coffee.id == rhs.coffee.id {
            return true
        }
        
        return false
    }

    var hashValue: Int {
        return 0
    }
    
}
