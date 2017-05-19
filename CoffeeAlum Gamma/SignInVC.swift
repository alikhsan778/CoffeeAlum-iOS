//
//  ViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/24/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn


class SignInVC: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    
    // Used to push the text field away from the keyboard to prevent keyboard overlapping
    var adaptiveKeyboard: AdaptiveKeyboard!
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!
    
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var backingView: UIView!
    
    
    // IBOutlet used for the button outlet to be called to adjust the size
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    
    
    // MARK: - App Cycle
    override func viewWillAppear(_ animated: Bool) {
        
        // Adding shadow
        backingView.addPresetCornerRadius()
        
        // Addjusting the sign up button font based on width
        signUpButtonOutlet.titleLabel?.numberOfLines = 1
        signUpButtonOutlet.titleLabel?.adjustsFontSizeToFitWidth = true
        signUpButtonOutlet.titleLabel?.lineBreakMode = .byClipping
        
        // Creating an instance of the SignUpSignInKeboardAdaptiveness class
        adaptiveKeyboard = AdaptiveKeyboard(scrollView: scrollViewOutlet, textField: emailTextFieldOutlet, passwordTextFieldOutlet, pushHeight: 80)
        
        // Prevents the user form being able to scroll the view
        scrollViewOutlet.isScrollEnabled = false
        
        // Register keyboard notifications before the view appears
        adaptiveKeyboard.registerKeyboardNotifications()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Setting the delegate to self. To be used to hide the keyboard
        emailTextFieldOutlet.delegate = self
        passwordTextFieldOutlet.delegate = self
        
        // Google sign in delegates
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        shadowView.addPresetShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Removes the keyboad notification when the view has changed
        adaptiveKeyboard.unregisterKeyboardNotifications()
    }
    
    
    // MARK: - IBActions
    @IBAction func signInButtonAction(_ sender: UIButton) {
        
        let emailRequirements = hasFullfilledEmailRequirementsIn(emailAddressTextField: emailTextFieldOutlet)
        let passwordRequirements = hasFulfilledPasswordRequirementsIn(textField: passwordTextFieldOutlet)
        
        if (emailRequirements == true) && (passwordRequirements == true) {
            
            FIRAuth.auth()?.signIn(withEmail: emailTextFieldOutlet.text!, password: passwordTextFieldOutlet.text!, completion: { (user, error) in
                
                if error == nil {
                    // Presents the home view controller
                    self.presentHomeViewController()
                    
                } else {
                    // print(error)
                }
                
            })
        }
        
    }
    
    
    @IBAction func googleSignInButton(_ sender: UIButton) {
        // Sign in using Google account
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    // MARK: - Login Essentials
    // Method to check if email address entered fulfills the requirements
    private func hasFullfilledEmailRequirementsIn(emailAddressTextField: UITextField) -> Bool {
        
        // Checks if the email address text field is empty
        if emailAddressTextField.text?.isEmpty == true {
            // TODO: Popup "Please enter your email address" alert
            displayUsefulErrorMessage(errorMessage: "Please enter your email address", label: emailAddressLabel)
            print("Please enter your email address")
            
            // Validates the email address
        } else if (validateEmailAddressIn(textField: emailAddressTextField) == true) {
            
            normalizeLabels(
                labelTitle: "Email address",
                label: emailAddressLabel
            )
            
            return true
            
        } else {
            // TODO: Popup "Please enter a valid email address" alert
            displayUsefulErrorMessage(errorMessage: "Please enter a valid email address", label: emailAddressLabel)
            print("Please enter a valid email address")
        }
        
        return false
    }
    
    // TODO: Make a class to not repeat the code
    // Method to check if the email address entered is valid
    private func validateEmailAddressIn(textField: UITextField) -> Bool {
        // Access the string in the text field
        let emailAddress = textField.text
        // Regular expression to validate email address
        let emailRegularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        // Uses NSPredicate to filter through the email address string using the Regular Expression
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegularExpression)
        // Returns a Bool to check if the condition passes
        return emailCheck.evaluate(with: emailAddress)
    }
    
    // Method that returns a Bool if the new password requirement is fulfilled
    private func hasFulfilledPasswordRequirementsIn(textField: UITextField) -> Bool {
        // Checks if the text field is empty to give an appropriate warning
        if textField.text?.isEmpty == true {
            // TODO: Popup "Please enter your new password" alert
            displayUsefulErrorMessage(errorMessage: "Please enter your password", label: passwordLabel)
            print("Please enter your password")
            
        } else {
            // Changes the Password label back to its normal state
            normalizeLabels(labelTitle: "Password", label: passwordLabel)
        }
        
        return true
    }
    
    // Method to show useful error message
    func displayUsefulErrorMessage(errorMessage message: String, label: UILabel) {
        // Changing the label into the useful error message
        label.text = message
        // Changing the color of the text to red
        label.textColor = UIColor.red
    }
    
    // Method to change the sign up labels back to its original
    func normalizeLabels(labelTitle: String, label: UILabel) {
        // Changing the label into the useful error message
        label.text = labelTitle
        // Changing the color of the text to red
        label.textColor = UIColor(colorLiteralRed: 116/255, green: 116/255, blue: 116/255, alpha: 1.0)
    }
    
    
    // Present the preferred home view controller
    fileprivate func presentHomeViewController() {
        
        // Accessing the App Delegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        // Accessing the storyboard
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: nil
        )
        // The next view controller
        let swRevealViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
        // Present the next view controller
        appDelegate?.window?.rootViewController = swRevealViewController
        
    }
    
    
    // MARK: - Keyboard Method
    // Method to hide the keyboard when editting the text
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
}

