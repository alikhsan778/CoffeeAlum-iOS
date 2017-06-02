//
//  CoffeeMeetupsViewController + Popover.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/16/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

extension CoffeeMeetupsVC {
    
    /// Setup for popver to make it fit the size of the screen
    func setupPopover(with data: Invitation) {
        
        let popoverContent = self.storyboard?.instantiateViewController(
            withIdentifier: "InvitationVC") as! InvitationVC
        
        // Popover content must have invitation data
        popoverContent.invitation = data
        popoverContent.delegate = self
        
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popoverContent.popoverPresentationController?.sourceView = self.view
        
        // Popover presentation controller
        let popover = popoverContent.popoverPresentationController
        popover?.delegate = self
        
        self.present(
            popoverContent,
            animated: true,
            completion: nil
        )
    }
    
    /// Required for the Popover transition
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    
}
