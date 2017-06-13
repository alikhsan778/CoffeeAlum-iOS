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
        case signInFailure(error: Error)
        case signInSuccess
        case googleSignIn
        case signingIn
        case loading
    }
    
    private enum `Error` {
        case emailAddressIsEmpty
        case passwordIsEmpty
        case passwordOrEmailIsIncorrect
    }
    
    @IBOutlet var mainView: SignInVCMainView!
    
    private var state: State = .default {
        didSet {
            didChangeState(state)
        }
    }

    // MARK: - App Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .loading
    }
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        state = .signingIn
    }
    
    @IBAction func googleSignInButtonAction(_ sender: UIButton) {
        state = .googleSignIn
    }
    
    private func didChangeState(_ state: State) {
        switch state {
        case .signingIn:
            signIn()
        case .signInSuccess:
            presentSearchViewController()
        case .signInFailure(let error):
            didChangeErrorState(error)
        case .googleSignIn:
            break
        default:
            break
        }
    }
    
    private func didChangeErrorState(_ error: Error) {
        
        var message: String
        let title = "Sign in error"
        let alertController = UIAlertController()
        
        switch error {
        case .emailAddressIsEmpty:
            message = "Please enter your email address."
        case .passwordIsEmpty:
            message = "Please enter your password."
        case .passwordOrEmailIsIncorrect:
            message = "Your password or email is incorrect."
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
    
    private func signIn() {
        if emailRequirementsIsFulfilled() && passwordRequirementsIsFulfilled() {
            
            let email = mainView.emailAddressTextField.text
            let password = mainView.passwordTextField.text
            
            APIClient.signIn(with: email!, password: password!) { [weak self] () in
                self?.state = .signInSuccess
            }
        }
    }
    
    // Method to check if email address entered fulfills the requirements
    private func emailRequirementsIsFulfilled() -> Bool {
        if mainView.emailAddressTextField.text == "" {
            state = .signInFailure(error: .emailAddressIsEmpty)
            return false
        }
        return true
    }
    
    // Method that returns a Bool if the new password requirement is fulfilled
    private func passwordRequirementsIsFulfilled() -> Bool {
        if mainView.passwordTextField.text == "" {
            state = .signInFailure(error: .passwordIsEmpty)
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

