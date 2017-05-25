//
//  SearchViewController + CustomPopover.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/9/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Firebase

extension SearchVC {
    
    // MARK: - Text Field Methods
    // Method that returns a Bool if the new password requirement is fulfilled
    func checkIfTextFieldHasBeenFilled(for textField: UITextField, showStatusIn label: UILabel) -> Bool {
        // Checks if the text field is empty to give an appropriate warning
        if textField.text?.isEmpty == true {
            // TODO: Popup "Please enter your new password" alert
            displayUsefulErrorMessage(errorMessage: label.text!,
                                      label: label)
            // Fails the check
            return false
            
        } else {
            normalizLabels(labelTitle: label.text!, label: label)
            // Passes the check
            return true
        }
        
    }
    
    // Method to show useful error message
    func displayUsefulErrorMessage(errorMessage message: String, label: UILabel) {
        // Changing the label into the useful error message
        label.text = message
        // Changing the color of the text to red
        label.textColor = UIColor.red
    }
    
    // Method to change the sign up labels back to its original
    func normalizLabels(labelTitle: String, label: UILabel) {
        // Changing the label into the useful error message
        label.text = labelTitle
        // Changing the color of the text to red
        label.textColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    }
    
    
    // MARK: - Keyboard Method
    // Method to hide the keyboard when editting the text
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        // Get the keyboard size
        
        
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
        
        view.frame.size = CGSize(width: self.view.frame.width * 0.90, height: self.view.frame.height * 0.95)
        view.center = self.view.center
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.view!.addSubview(view)
        
        // Bringing the popover view to front
        self.view!.bringSubview(toFront: view)
        
        print(completeProfileView.center.y)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {() -> Void in
            view.transform = CGAffineTransform.identity
            
            // Creates the blur effect
            self.view.addSubview(self.blurEffectView)
            // Sending the blur effect to be behind the popover
            self.view.sendSubview(toBack: self.blurEffectView)
            
        }, completion: nil)
        
    }
    
    // Method to dimiss the popover
    func dismissPopover(view: UIView) {
        // Animation to dismiss the popover
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {() -> Void in
            // Animation to scale before disappearing
            view.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
            
            view.alpha = 0
            self.blurEffectView.removeFromSuperview()
            
            // Updating this bool to prevent this popup from showing again
            userHasCompletedProfileRequirements = true
            // Update the status bar
            self.setNeedsStatusBarAppearanceUpdate()
            
        }, completion: { (success: Bool) in
            view.removeFromSuperview()
        })
        
    }
    

    
}
