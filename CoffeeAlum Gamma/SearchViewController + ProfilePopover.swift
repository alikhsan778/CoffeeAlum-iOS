//
//  SearchViewController + ProfilePopover.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/16/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

// Setting up profile glimpse popover
extension SearchViewController {
    
    func setupProfileGlimpsePopover() {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "ProfileGlimpse") as! ProfileGlimpseViewController
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = popoverContent.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.9)
        
        popover?.delegate = self
        
        popoverContent.popoverPresentationController?.sourceView = self.view
        popoverContent.popoverPresentationController?.sourceRect = CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0)
        
        popoverContent.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
}
