//
//  SearchViewController + CustomPopover.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/9/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//


extension SearchVC {
    
    // MARK: - Keyboard Method
    // Method to hide the keyboard when editting the text
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }

    // MARK: - Popover Method
    // Sets up the popover
    func setupPopover(view: UIView) {
        if userHasCompletedProfileRequirements == true {
            // Sets up the reveal view controller for sidebar menu
            self.setupRevealViewController()
            return
        }
        
        view.frame.size = CGSize(
            width: self.view.frame.width * 0.90,
            height: self.view.frame.height * 0.95)
        view.center = self.view.center
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.view!.addSubview(view)
        
        // Bringing the popover view to front
        self.view!.bringSubview(toFront: view)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {() -> Void in
            view.transform = CGAffineTransform.identity
            
            // Creates the blur effect
            self.view.addSubview(self.searchVCMainView.blurEffectView)
            // Sending the blur effect to be behind the popover
            self.view.sendSubview(toBack: self.searchVCMainView.blurEffectView)
            
        }, completion: nil)
    }
    
    // Method to dimiss the popover
    func dismissPopover(view: UIView) {
        // Animation to dismiss the popover
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: { () -> Void in
            // Animation to scale before disappearing
            view.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
            
            view.alpha = 0
            self.searchVCMainView.blurEffectView.removeFromSuperview()
            
            // Updating this bool to prevent this popup from showing again
            userHasCompletedProfileRequirements = true
            // Update the status bar
            self.setNeedsStatusBarAppearanceUpdate()
            
        }, completion: { (success: Bool) in
            view.removeFromSuperview()
        })
        
    }
    

    
}
