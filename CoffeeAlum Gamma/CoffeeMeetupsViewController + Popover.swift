//
//  CoffeeMeetupsViewController + Popover.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/16/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

extension CoffeeMeetupsViewController {
    
    func setupPopover() {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "InvitationViewController") as! InvitationViewController
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = popoverContent.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: self.view.frame.width * 0.85, height: self.view.frame.height * 0.85)
        
        popover?.delegate = self
        
        popoverContent.popoverPresentationController?.sourceView = self.view
        popoverContent.popoverPresentationController?.sourceRect = CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0)
        
        popoverContent.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    // Required for the Popover transition
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    
}
