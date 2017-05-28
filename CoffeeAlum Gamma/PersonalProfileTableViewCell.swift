//
//  PersonalProfileTableViewCell.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 2/8/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

protocol PersonalProfileDelegate {
    func updateUserInformation()
}

final class PersonalProfileTableViewCell: UITableViewCell {
    
    // Delegate object
    var delegate: PersonalProfileDelegate!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var occupationTextField: UITextField!
    
    @IBOutlet weak var employerTextField: UITextField!
    
    @IBOutlet weak var educationalBackgroundTextField: UITextField!
    
    @IBOutlet weak var linkedInProfileTextField: UITextField!
    
    
    
}
