//
//  SignUpVCMainView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 6/6/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit


class SignUpVCMainView: UIView {
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet weak var passwordTitleLabel: UILabel!
    
    @IBOutlet weak var confirmPasswordTitleLabel: UILabel!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        
        let emailCondition = hasFullfilledEmailRequirementsIn(emailAddressTextField: emailAddressTextField)
        let passwordCondition = hasFulfilledPasswordRequirementsIn(textField: passwordTextField)
        let confirmPasswordCondition = hasFulfilledConfirmPasswordRequirements()
        
    }
    
    @IBAction func googleSignUpButtonAction(_ sender: UIButton) {
        
        
        
    }
    
    // Method to change the sign up labels back to its original
    func normalizeLabels(labelTitle: String, label: UILabel) {
        // Changing the label into the useful error message
        label.text = labelTitle
        // Changing the color of the text to red
        label.textColor = UIColor(colorLiteralRed: 116/255, green: 116/255, blue: 116/255, alpha: 1.0)
    }
    
    // Method to show useful error message
    func displayUsefulErrorMessage(errorMessage message: String, label: UILabel) {
        label.text = message
        label.textColor = UIColor.red
    }
    
    // Method to hide the keyboard when the return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    // Method to check if email address entered fulfills the requirements
    private func hasFullfilledEmailRequirementsIn(emailAddressTextField: UITextField) -> Bool {
        // Checks if the email address text field is empty
        if emailAddressTextField.text?.isEmpty == true {
            
            // TODO: TODO: Popup "Please enter your email address" alert
            displayUsefulErrorMessage(
                errorMessage: "Please enter your email address",
                label: emailAddressLabel
            )
            
            print("Please enter your email address")
            
            // Validates the email address
        } else if (validateEmailAddressIn(textField: emailAddressTextField) == true) {
            
            normalizeLabels(
                labelTitle: "Email address",
                label: emailAddressLabel
            )
            
            return true
            
        } else {
            // TODO: TODO: Popup "Please enter a valid email address" alert
            displayUsefulErrorMessage(
                errorMessage: "Please enter a valid email address",
                label: emailAddressLabel
            )
            
            print("Please enter a valid email address")
        }
        
        return false
    }
    
    // Method to check if the password contains enough characters
    private func hasEnoughCharactersIn(textField: UITextField) -> Bool {
        // Number of characters in the text field
        let characterCountInTextField = textField.text?.characters.count
        // At least 6 characters is needed for the text field
        if characterCountInTextField! >= 6 {
            return true
        }
        
        return false
    }
    
    // Method to check if the email address entered is valid
    private func validateEmailAddressIn(textField: UITextField) -> Bool {
        let emailAddress = textField.text
        let emailRegularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        // Uses NSPredicate to filter through the email address string using the Regular Expression
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegularExpression)
        // Returns a Bool to check if the condition passes
        return emailCheck.evaluate(with: emailAddress)
    }
    
    // Method to check if the password entered matches the confirm password
    private func passwordMatchesIn() -> Bool {
        
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        if password == confirmPassword {
            return true
        }
        return false
    }
    
    // TODO: Refactor
    // Method that returns a Bool if the new password matches the confirmed password
    private func hasFulfilledConfirmPasswordRequirements() -> Bool {
        
        guard let _ = confirmPasswordTextField.text else {
            
            // TODO: TODO: Throw error
            
            displayUsefulErrorMessage(errorMessage: "Please re-enter your new password", label: confirmPasswordTitleLabel)
            print("Please re-enter your new password to confirm")
            
            return false
        }
        
       if passwordMatchesIn() == true {
            
            normalizeLabels(labelTitle: "Confirm password", label: confirmPasswordTitleLabel)
            
            return true
            
        } else {
            // TODO: TODO: Popup "Your password does not match" alert
            displayUsefulErrorMessage(errorMessage: "Your password does not match", label: confirmPasswordTitleLabel)
        }
        
        return false
    }
    
    // Method that returns a Bool if the new password requirement is fulfilled
    private func hasFulfilledPasswordRequirementsIn(textField: UITextField) -> Bool {
        // Checks if the text field is empty to give an appropriate warning
        if textField.text?.isEmpty == true {
            // TODO: TODO: Popup "Please enter your new password" alert
            displayUsefulErrorMessage(errorMessage: "Please enter your new password", label: passwordTitleLabel)
            print("Please enter your new password")
            
            // Checks if the password text field is has enough characters
        } else if hasEnoughCharactersIn(textField: textField) == true {
            normalizeLabels(labelTitle: "Password", label: passwordTitleLabel)
            return true
            
        } else {
            // TODO: TODO: Popup "You need to have at least 6 characters" alert
            displayUsefulErrorMessage(errorMessage: "Password needs at least 6 characters", label: passwordTitleLabel)
            print("You need to have at least 6 characters")
        }
        
        return false
    }
    
    
}
