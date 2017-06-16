//
//  ViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/24/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit


final class SignUpVC: UIViewController {
    
    /// States of the view controller.
    // MARK: - States
    private enum State {
        case `default`
        case signUpFailed(as: Error)
        case signUpSuccessful
        case googleSignUp
        case signingUp
        case loading
    }
    
    private enum `Error` {
        case emailAddressIsEmpty
        case emailAddressIsInvalid
        case emailAddressAlreadyInUse
        case passwordIsEmpty
        case passwordIsInvalid
        case passwordConfirmationIsEmpty
        case passwordConfirmationDoesNotMatch
    }
    
    private var state: State = .default {
        didSet {
            didChange(state)
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet var mainView: SignUpVCMainView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .loading
    }
    
    // MARK: - IBActions
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        state = .signingUp
    }
    
    @IBAction func googleSignInButtonAction(_ sender: UIButton) {
        state = .googleSignUp
    }
    
    // MARK: - State Machine
    private func didChange(_ state: State) {
        switch state {
        case .signingUp:
            signUp()
        case .signUpSuccessful:
            presentSearchViewController()
        case .signUpFailed(let error):
            throwWarning(for: error)
        case .googleSignUp:
            googleSignUp()
        default:
            break
        }
    }
    
    // MARK: - Sign Up Success
    private func signUp() {
        
        let email = mainView.emailAddressTextField.text
        let password = mainView.passwordTextField.text
        
        if emailRequirementsIsFulfilled() && passwordRequirementsIsFulfilled() &&  confirmPasswordRequirementsIsFulfilled() {
            
            APIClient.signUp(with: email!, password: password!) { [weak self] in
                self?.state = .signUpSuccessful
            }
        }
    }
    
    private func googleSignUp() {
        APIClient.googleSignIn { [weak self] in
            self?.state = .signUpSuccessful
        }
    }
    
    // MARK: - Error Handler
    private func throwWarning(for error: Error) {
        
        var message: String
        let title = "Sign up error"
        let alertController = UIAlertController()
        
        switch error {
        case .emailAddressIsEmpty:
            message = "Please enter your email address."
        case .emailAddressIsInvalid:
            message = "Your email address is invalid."
        case .emailAddressAlreadyInUse:
            message = "Your email address is already used."
        case .passwordIsEmpty:
            message = "Please enter your password."
        case .passwordConfirmationIsEmpty:
            message = "Please re-enter your password."
        case .passwordIsInvalid:
            message = "Your password requires at least 6 characters."
        case .passwordConfirmationDoesNotMatch:
            message = "Your password confirmation does not match."
        }
        
        func addAlertControllerTapGesture() {
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(alertControllerTapGestureHandler)
            )
            let alertControllerSubview = alertController.view.superview?.subviews[1]
            alertControllerSubview?.isUserInteractionEnabled = true
            alertControllerSubview?.addGestureRecognizer(tapGesture)
        }
        
        alertController.title = title
        alertController.message = message
        
        present(alertController, animated: true) {
            addAlertControllerTapGesture()
        }
        
    }
    
    @objc private func alertControllerTapGestureHandler() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Sign Up Failure
    // Method to check if email address entered fulfills the requirements
    private func emailRequirementsIsFulfilled() -> Bool {
        
        if mainView.emailAddressTextField.text == "" {
            state = .signUpFailed(as: .emailAddressIsEmpty)
            return false
        }
        
        // Validates the email address
        if emailAddressIsValidated() {
            return true
        } else {
            state = .signUpFailed(as: .emailAddressIsInvalid)
        }
        
        return true
    }
    
    // Method that returns a Bool if the new password matches the confirmed password
    private func confirmPasswordRequirementsIsFulfilled() -> Bool {
        
        if mainView.confirmPasswordTextField.text == "" {
            state = .signUpFailed(as: .passwordConfirmationIsEmpty)
            return false
        }
        
        if passwordMatches() {
            return true
        } else {
            state = .signUpFailed(as: .passwordConfirmationDoesNotMatch)
        }
        
        return false
    }
    
    private func passwordRequirementsIsFulfilled() -> Bool {
        
        if mainView.passwordTextField.text == "" {
            state = .signUpFailed(as: .passwordIsEmpty)
            return false
        }
        
        // Checks if the password text field is has enough characters
        if passwordHasEnoughCharacters() {
            return true
        } else {
            state = .signUpFailed(as: .passwordIsInvalid)
        }
        
        return false
    }
    
    // Method to check if the password contains enough characters
    private func passwordHasEnoughCharacters() -> Bool {
        // Number of characters in the text field
        let passwordCharacterCount = mainView.passwordTextField.text?.characters.count
        // At least 6 characters is needed for the text field
        if passwordCharacterCount! >= 6 {
            return true
        }
        
        state = .signUpFailed(as: .passwordIsInvalid)
        return false
    }
    
    // Method to check if the email address entered is valid
    private func emailAddressIsValidated() -> Bool {
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
            state = .signUpFailed(as: .emailAddressIsInvalid)
            return false
        }
    }
    
    // Method to check if the password entered matches the confirm password
    private func passwordMatches() -> Bool {
        let password = mainView.passwordTextField.text
        let passwordConfirmation = mainView.confirmPasswordTextField.text
        
        if password == passwordConfirmation {
            return true
        } else {
            state = .signUpFailed(as: .passwordConfirmationDoesNotMatch)
            return false
        }
    }
    
    // MARK: - Sign Up Successful
    private func presentSearchViewController() {
        // Accessing the App Delegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let storyboard = UIStoryboard(
            name: Storyboard.main.rawValue,
            bundle: nil
        )
        let targetController = storyboard.instantiateViewController(
            withIdentifier: ViewController.SWRevealViewController.rawValue) as! SWRevealViewController
        
        // Present the next view controller
        appDelegate?.window?.rootViewController = targetController
    }
  
}

