//
//  ViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/24/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class SignInVC: UIViewController {
    
    /// States of the view controller.
    private enum State {
        case `default`
        case signInFailed(as: Error)
        case signInSuccessful
        case signInWithGoogleAccount
        case signInUsingFirebase
        case loading
    }
    
    private enum `Error` {
        case emailAddressIsEmpty
        case passwordIsEmpty
        case passwordOrEmailIsIncorrect
        case firebase(Swift.Error)
    }
    
    @IBOutlet var mainView: SignInVCMainView!
    
    private let alertController = UIAlertController()
    
    private var state: State = .default {
        didSet {
            didChange(state)
        }
    }

    // MARK: - App Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .loading
    }
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        state = .signInUsingFirebase
    }
    
    @IBAction func googleSignInButtonAction(_ sender: UIButton) {
        state = .signInWithGoogleAccount
    }
    
    private func didChange(_ state: State) {
        switch state {
        case .signInUsingFirebase:
            signInUsingFirebase()
        case .signInSuccessful:
            presentSearchViewController()
        case .signInFailed(let error):
            throwWarning(for: error)
        case .signInWithGoogleAccount:
            break
        default:
            break
        }
    }
    
    private func throwWarning(for error: Error) {
        
        var message: String
        let title = "Sign in error"
        
        switch error {
        case .emailAddressIsEmpty:
            message = "Please enter your email address."
        case .passwordIsEmpty:
            message = "Please enter your password."
        case .passwordOrEmailIsIncorrect:
            message = "Your password or email is incorrect."
        case .firebase(let error):
            message = "\(error.localizedDescription)"
        }
        
        func setupAlertControllerTapGesture() {
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
            setupAlertControllerTapGesture()
        }
        
    }
    
    @objc private func alertControllerTapGestureHandler() {
        dismiss(animated: true, completion: nil)
    }
    
    private func signInUsingFirebase() {
        if emailRequirementsIsFulfilled() && passwordRequirementsIsFulfilled() {
            
            let email = mainView.emailAddressTextField.text
            let password = mainView.passwordTextField.text
            
            APIClient.signIn(with: email!, password: password!) { [weak self] (error) in
                if error == nil {
                    self?.state = .signInSuccessful
                } else {
                    self?.state = .signInFailed(as: .firebase(error!))
                }
            }
        }
    }
    
    // Method to check if email address entered fulfills the requirements
    private func emailRequirementsIsFulfilled() -> Bool {
        if mainView.emailAddressTextField.text == "" {
            state = .signInFailed(as: .emailAddressIsEmpty)
            return false
        }
        return true
    }
    
    // Method that returns a Bool if the new password requirement is fulfilled
    private func passwordRequirementsIsFulfilled() -> Bool {
        if mainView.passwordTextField.text == "" {
            state = .signInFailed(as: .passwordIsEmpty)
            return false
        }
        return true
    }
    
    private func presentSearchViewController() {
        // Accessing the App Delegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let storyboard = UIStoryboard(
            name: Storyboard.main.rawValue,
            bundle: nil
        )
        let targetViewController = storyboard.instantiateViewController(
            withIdentifier: ViewController.SWRevealViewController.rawValue) as! SWRevealViewController
        
        // Present the next view controller
        appDelegate?.window?.rootViewController = targetViewController
        
    }
 
}

