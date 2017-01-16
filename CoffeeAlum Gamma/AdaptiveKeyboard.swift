//
//  KeyboardAdaptiveness.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/30/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit


class AdaptiveKeyboard {
    // MARK: - Keyboard Methods
    // Method to store all the NSNotifications for the keyboard observer
    // Used for keyboard show and hide status
    
    var scrollView: UIScrollView!
    var arrayOfTextField: [UITextField?]
    var pushHeight: CGFloat!
    
    init(scrollView: UIScrollView, textField: UITextField..., pushHeight: CGFloat) {
        self.scrollView = scrollView
        self.arrayOfTextField = textField
        self.pushHeight = pushHeight
    }
    
    // Using convenience init makes calling this property possible without initializing
    // Example: signUpSignInAdaptiveKeyboard.confirmPasswordTextField = confirmPasswordTextField
    convenience init(confirmPasswordTextfield: UITextField) {
        self.init(confirmPasswordTextfield: confirmPasswordTextfield)
    }
    
    // Compiles all the notifications
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showKeyboardAndAdjustScrollView(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideKeyboardAndAdjustScrollView(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    // Removes the observer, used in viewWillDisappear
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    
    // Method to give room for the textfield when using keyboard
    @objc func showKeyboardAndAdjustScrollView(notification: NSNotification) {
        
        // Accessing the NSNotificatio of the user information, used to access the keyboard
        let info = notification.userInfo!
        // Getting the Keyboard Frame
        let keyboardSize: CGSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        // Using the keyboard frame to push the sign up view
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + pushHeight, right: 0)
        
        // Checks which keyboard is being editted, stops the user from being able to scroll
        for textField in arrayOfTextField {
            if textField!.isEditing == true {
                
                // Animation to push the scroll to prevent the kebyoard from overlapping
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.scrollView.contentInset = contentInsets
                    self.scrollView.scrollIndicatorInsets = contentInsets
                    self.scrollView.isScrollEnabled = true
                    
                    // Completion block disables the scroll after the scroll is pushed by keyboard
                }, completion: { (complete: Bool) in
                    self.scrollView.isScrollEnabled = false
                    return
                })
                
            }
        }
        
    }
    
    // Method to unscroll the scroll view when the keyboard hides
    @objc func hideKeyboardAndAdjustScrollView(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
}
