//
//  SearchViewController + ProfilePopover.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/16/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

// Setting up profile glimpse popover

extension SearchVC {
    
    func setupProfileGlimpsePopover(userViewed: User) {
        let popoverContent = self.storyboard?.instantiateViewController(
            withIdentifier: "ProfileGlimpse") as! ProfileGlimpseVC
        
        // pass the user data
        popoverContent.userViewed = userViewed
        popoverContent.thisUser = self.thisUser
        
        // popover view mechanics
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
}
