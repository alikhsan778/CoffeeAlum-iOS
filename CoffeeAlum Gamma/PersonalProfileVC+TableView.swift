//
//  PersonalProfileVC+TableView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 2/8/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

extension PersonalProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let nibFile = UINib(nibName: "PersonalProfileTableViewCell", bundle: nil)
        tableView.register(nibFile, forCellReuseIdentifier: "PersonalProfileCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalProfileCell") as! PersonalProfileTableViewCell
        
        let elementFromIndex = userList[indexPath.row]
        
        
        // TODO: thisUser is nil
        cell.nameTextField.text = elementFromIndex.name
        cell.emailTextField.text = elementFromIndex.email
        cell.occupationTextField.text = elementFromIndex.role
        
        cell.employerTextField.text  = elementFromIndex.employer
        cell.educationalBackgroundTextField.text = elementFromIndex.education
        // cell.personalWebsiteTextField.text = website
        // cell.bioTextField.text = bio
        cell.linkedInProfileTextField.text = elementFromIndex.linkedIn
        // cell.profilePicture.image = image.toImage()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.view.frame.height * 0.8)
    }
    
}
