//
//  PersonalProfileTableViewCell.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 2/8/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol PersonalProfileDelegate: class {
    func save(user update: User)
}

final class PersonalProfileTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    // Delegate object
    weak var delegate: PersonalProfileDelegate!
    fileprivate var user: User!
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var employerTextField: UITextField!
    @IBOutlet weak var educationalBackgroundTextField: UITextField!
    @IBOutlet weak var linkedInProfileTextField: UITextField!
    
    func configure(with user: User) {
        nameTextField.text = user.name
        emailTextField.text = user.email
        occupationTextField.text = user.role
        employerTextField.text  = user.employer
        educationalBackgroundTextField.text = user.education
        // personalWebsiteTextField.text = website
        // bioTextField.text = bio
        linkedInProfileTextField.text = user.linkedIn
        // profilePicture.image = image.toImage()
        
        self.user = user
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        occupationTextField.delegate = self
        employerTextField.delegate = self
        educationalBackgroundTextField.delegate = self
        linkedInProfileTextField.delegate = self
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        addTextToUserData()
        delegate.save(user: user)
    }
    
    fileprivate func addTextToUserData() {
        // TODO: Use the textField parameter to update only what's necessary
        user.name = nameTextField.text!
        user.email = emailTextField.text!
        user.employer = employerTextField.text!
        user.role = occupationTextField.text!
        user.education = educationalBackgroundTextField.text!
        user.linkedIn = linkedInProfileTextField.text!
    }
    
}
