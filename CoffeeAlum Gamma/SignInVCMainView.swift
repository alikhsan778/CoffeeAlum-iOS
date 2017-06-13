//
//  SignInVCMainView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 6/10/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class SignInVCMainView: UIView {
    
    @IBOutlet weak var emailAddressTitleLabel: UILabel!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backingView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()

        backingView.addPresetCornerRadius()
    }

}
