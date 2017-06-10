//
//  ViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/24/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class SignUpVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet var mainView: SignUpVCMainView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup text field delegates
        setupTextFieldDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        // Adding corner radius
        mainView.backingView.addPresetCornerRadius()
    }
    
    // MARK: - Setup Methods
    fileprivate func setupTextFieldDelegates() {
        mainView.emailAddressTextField.delegate = self
        mainView.passwordTextField.delegate = self
        mainView.confirmPasswordTextField.delegate = self
    }
    
    // Method to hide the keyboard when the return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

