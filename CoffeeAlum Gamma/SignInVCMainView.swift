//
//  SignInVCMainView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 6/10/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class SignInVCMainView: UIView {
    
    @IBOutlet weak var emailAddressTitleLabel: UILabel!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backingView: UIView!
    
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        
        guard let email = emailAddressTextField.text, let password = passwordTextField.text else {
            return
        }
        
        if emailRequirementsIsFulfilled() && passwordRequirementsIsFulfilled() {
            
            APIClient.signIn(with: email, password: password) { [weak self] () in
                
                self?.presentSearchViewController()
                
            }
            
        }
        
    }
    
    @IBAction func googleSignInButtonAction(_ sender: UIButton) {
        
    }
    
    // Method to change the sign up labels back to its original
    fileprivate func normalizeLabels(labelTitle: String, label: UILabel) {
        // Changing the label into the useful error message
        label.text = labelTitle
        // Changing the color of the text to red
        label.textColor = UIColor(
            colorLiteralRed: 116/255,
            green: 116/255,
            blue: 116/255,
            alpha: 1.0
        )
    }
    
    // Method to show useful error message
    fileprivate func displayUsefulErrorMessage(with message: String, label: UILabel) {
        
        label.text = message
        label.textColor = UIColor.red
    }
    
    // Method to check if email address entered fulfills the requirements
    fileprivate func emailRequirementsIsFulfilled() -> Bool {
        
        guard let _ = emailAddressTextField.text else {
            
            displayUsefulErrorMessage(
                with: "Please enter your email address",
                label: emailAddressTitleLabel
            )
            
            // TODO: TODO: Popup "Please enter your email address" alert
            
            print("Please enter your email address")
            
            return false
        }
        
        // Validates the email address
        if emailAddressIsValidated() {
            
            normalizeLabels(
                labelTitle: "Email address",
                label: emailAddressTitleLabel
            )
            
            return true
            
        } else {
            
            // TODO: TODO: Popup "Please enter a valid email address" alert
            
            displayUsefulErrorMessage(
                with: "Please enter a valid email address",
                label: emailAddressTitleLabel
            )
            
            print("Please enter a valid email address")
        }
        
        return false
    }
    
    // Method to check if the password contains enough characters
    fileprivate func passwordHasEnoughCharacters() -> Bool {
        // Number of characters in the text field
        let characterCountInTextField = passwordTextField.text?.characters.count
        // At least 6 characters is needed for the text field
        if characterCountInTextField! >= 6 {
            return true
        }
        
        return false
    }
    
    // Method to check if the email address entered is valid
    fileprivate func emailAddressIsValidated() -> Bool {
        
        let emailAddress = emailAddressTextField.text
        let emailRegularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        // Uses NSPredicate to filter through the email address string using the Regular Expression
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegularExpression)
        
        // Returns a Bool to check if the condition passes
        return emailCheck.evaluate(with: emailAddress)
    }
    
    
    // TODO: Refactor
    // Method that returns a Bool if the new password requirement is fulfilled
    fileprivate func passwordRequirementsIsFulfilled() -> Bool {
        // Checks if the text field is empty to give an appropriate warning
        
        guard let _ = passwordTextField.text else {
            
            // TODO: TODO: Popup "Please enter your new password" alert
            displayUsefulErrorMessage(
                with: "Please enter your new password",
                label: passwordTitleLabel
            )
            
            print("Please enter your new password")
            
            return false
        }
        
        // Checks if the password text field is has enough characters
        if passwordHasEnoughCharacters() {
            
            normalizeLabels(
                labelTitle: "Password",
                label: passwordTitleLabel
            )
            
            return true
            
        } else {
            
            // TODO: TODO: Popup "You need to have at least 6 characters" alert
            displayUsefulErrorMessage(
                with: "Password needs at least 6 characters",
                label: passwordTitleLabel
            )
            
            print("You need to have at least 6 characters")
        }
        
        return false
    }
    
    
    fileprivate func presentSearchViewController() {
        
        // Accessing the App Delegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swRevealViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        
        // Present the next view controller
        appDelegate?.window?.rootViewController = swRevealViewController
        
    }

}