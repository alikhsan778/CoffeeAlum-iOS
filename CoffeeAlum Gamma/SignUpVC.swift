//
//  ViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/24/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit


final class SignUpVC: UIViewController {
    
    // VIEW CONTROLLERS KNOW ABOUT ACTIONS
    // VIEW CONTROLLERS KNOW ABOUT STATE CHANGES
    
    /// States of the view controller.
    fileprivate enum State {
        case `default`
        case signUpFailure(error: Error)
        case signUpSuccess
        case googleSigningUp
        case signingUp
        case loading
    }
    
    fileprivate enum `Error` {
        case emailAddressIsEmpty
        case emailAddressIsInvalid
        case emailAddressAlreadyUsed
        case passwordIsEmpty
        case passwordConfirmationIsEmpty
        case passwordIsInvalid
        case unmatchingPasswordConfirmation
    }
    
    fileprivate var state: State = .default {
        didSet {
            didChangeState(state)
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet var mainView: SignUpVCMainView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .loading
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        state = .signingUp
    }
    
    @IBAction func googleSignInButtonAction(_ sender: UIButton) {
        state = .googleSigningUp
    }
    
    fileprivate func didChangeState(_ state: State) {
        switch state {
        case .signingUp:
            signUp()
        case .signUpSuccess:
            presentSearchViewController()
        case .signUpFailure(let error):
            errorHandler(error)
        case .googleSigningUp:
            googleSignUp()
        default:
            break
        }
    }
    
    fileprivate func signUp() {
        
        guard let email = mainView.emailAddressTextField.text, let password = mainView.passwordTextField.text else {
            return
        }
        
        if emailRequirementsIsFulfilled() && passwordRequirementsIsFulfilled() &&  confirmPasswordRequirementsIsFulfilled() {
            
            APIClient.signUp(with: email, password: password) { [weak self] in
                self?.state = .signUpSuccess
            }
        }
    }
    
    fileprivate func googleSignUp() {
        APIClient.googleSignIn { [weak self] in
            self?.state = .signUpSuccess
        }
        
    }
    
    fileprivate func errorHandler(_ error: Error) {
        
        var message: String
        let alertView = UIAlertView()
        
        switch error {
        case .emailAddressIsEmpty:
            message = "Please enter your email address."
        case .emailAddressIsInvalid:
            message = "Your email address is invalid."
        case .emailAddressAlreadyUsed:
            message = "Your email address is already used."
        case .passwordIsEmpty:
            message = "Please enter your password."
        case .passwordConfirmationIsEmpty:
            message = "Please re-enter your password."
        case .passwordIsInvalid:
            message = "Your password requires at least 6 characters."
        case .unmatchingPasswordConfirmation:
            message = "Your password confirmation does not match."
        }
        
        alertView.title = message
        present(alertView, animated: true, completion: nil)
        
    }
    
    // Method to check if email address entered fulfills the requirements
    fileprivate func emailRequirementsIsFulfilled() -> Bool {
        
        if mainView.emailAddressTextField.text == nil {
            state = .signUpFailure(error: .emailAddressIsEmpty)
            return false
        }
        
        // Validates the email address
        if emailAddressIsValidated() {
            return true
        } else {
            state = .signUpFailure(error: .emailAddressIsInvalid)
        }
        
        return true
    }
    
    // Method to check if the password contains enough characters
    fileprivate func passwordHasEnoughCharacters() -> Bool {
        // Number of characters in the text field
        let passwordCharacterCount = mainView.passwordTextField.text?.characters.count
        // At least 6 characters is needed for the text field
        if passwordCharacterCount! >= 6 {
            return true
        }
        
        state = .signUpFailure(error: .passwordIsInvalid)
        return false
    }
    
    // Method to check if the email address entered is valid
    fileprivate func emailAddressIsValidated() -> Bool {
        let emailAddress = mainView.emailAddressTextField.text
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        // Uses NSPredicate to filter through the email address string using the Regular Expression
        let emailFilter = NSPredicate(
            format:"SELF MATCHES %@",
            regularExpression
        )
        
        let emailIsValidated = emailFilter.evaluate(with: emailAddress)
        
        if emailIsValidated {
            return true
        } else {
            state = .signUpFailure(error: .emailAddressIsInvalid)
            return false
        }
    }
    
    // Method to check if the password entered matches the confirm password
    fileprivate func passwordMatches() -> Bool {
        let password = mainView.passwordTextField.text
        let passwordConfirmation = mainView.confirmPasswordTextField.text
        
        if password == passwordConfirmation {
            return true
        } else {
            state = .signUpFailure(error: .unmatchingPasswordConfirmation)
            
            return false
        }
    }
    
    // Method that returns a Bool if the new password matches the confirmed password
    fileprivate func confirmPasswordRequirementsIsFulfilled() -> Bool {
        
        if mainView.confirmPasswordTextField.text == nil {
            state = .signUpFailure(error: .passwordConfirmationIsEmpty)
            return false
        }
        
        if passwordMatches() {
            return true
        } else {
            state = .signUpFailure(error: .unmatchingPasswordConfirmation)
        }
        
        return false
    }
    
    fileprivate func passwordRequirementsIsFulfilled() -> Bool {
        // Checks if the text field is empty to give an appropriate warning
        
        if mainView.passwordTextField.text == nil {
            state = .signUpFailure(error: .passwordIsEmpty)
            return false
        }
        
        // Checks if the password text field is has enough characters
        if passwordHasEnoughCharacters() {
            return true
        } else {
            state = .signUpFailure(error: .passwordIsInvalid)
        }
        
        return false
    }
    
    
    fileprivate func presentSearchViewController() {
        
        // Accessing the App Delegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let storyboard = UIStoryboard(
            name: Storyboard.main.rawValue,
            bundle: nil
        )
        let swRevealViewController = storyboard.instantiateViewController(
            withIdentifier: "SWRevealViewController") as! SWRevealViewController
        
        // Present the next view controller
        appDelegate?.window?.rootViewController = swRevealViewController
        
    }
  
}

