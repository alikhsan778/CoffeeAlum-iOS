//
//  InvitePopoverViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/15/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Firebase

class InvitePopoverViewController: UIViewController {
    var viewedUser: User?
    var thisUser: User?
    var date: String?
    var time: String?
    var location: String?
    
    
    @IBAction func inviteButtonAction(_ sender: UIButton) {
        if inviteComplete(){
            let coffee = Coffee(date: date!, time: time!, location: location!
                , fromId: thisUser!.uid, toId: viewedUser!.uid, fromName: thisUser!.name, toName: viewedUser!.name)
            coffee.dateSent = Date().convertToString()
        }
        
        
        
    }
    
    @IBAction func dateTextField(_ sender: UITextField) {
        
    }
    
    @IBAction func timeTextField(_ sender: UITextField) {
        
    }
    
    override func viewDidLoad() {
        
        
    }
    
    func inviteComplete() -> Bool{
        if let date = self.date, let time = self.time, let location = self.location {
            return true
        }else{return false}
    }
    
    
    
    
}
