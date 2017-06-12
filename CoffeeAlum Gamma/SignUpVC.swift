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
        case incompletePasswordConfirmation
        case incompletePassword
        case signUpFailure(error: Error)
        case signUpSuccess
        case googleSigningUp
        case signingUp
        case loading
    }
    
    fileprivate enum `Error` {
        case emailAddressEmpty
        case emailAddressInvalid
        case emailAddressAlreadyUsed
        case passwordEmpty
        case passwordConfirmationEmpty
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
            mainView.presentSearchViewController()
        case .signUpFailure(let error):
            errorHandler(error: error)
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
        
        if mainView.emailRequirementsIsFulfilled() && mainView.passwordRequirementsIsFulfilled() &&  mainView.confirmPasswordRequirementsIsFulfilled() {
            
            APIClient.signUp(with: email, password: password) { [weak self] () in
                
                self?.state = .signUpSuccess
                
            }
            
        }
        
    }
    
    fileprivate func googleSignUp() {
        
        APIClient.googleSignIn { [weak self] in
            self?.state = .signUpSuccess
        }
        
    }
    
    fileprivate func errorHandler(error: Error) {
        switch error {
        case .emailAddressEmpty:
            break
        case .emailAddressInvalid:
            break
        case .passwordEmpty:
            break
        default:
            break
        }
    }
  
}

