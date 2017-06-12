//
//  SignUpVCMainView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 6/6/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

// VIEW IS JUST A CANVAS, IT SHOULDN'T CONTAIN CODE ABOUT STATE
final class SignUpVCMainView: UIView {
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var confirmPasswordTitleLabel: UILabel!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var backingView: UIView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backingView.addPresetCornerRadius()
    }
    
}
