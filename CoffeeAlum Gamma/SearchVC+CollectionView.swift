//
//  SearchViewController + CollectionView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/9/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

// MARK: - Collection View Extension
// Extension of the View Controller for the CollectionView
extension SearchVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Setup to enable profile glimpse popover
        let user = filteredUsers[indexPath.row]
        setupProfileGlimpsePopover(viewedUser:user)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCollectionViewCell
        
        let userForCell = filteredUsers[indexPath.row]
        
        cell.userNameLabelOutlet.text = userForCell.name
        cell.studentOrAlumLabel.text! = userForCell.account.rawValue
        cell.userCityLocationLabel.text! = userForCell.location
        
        //If has job, label = job, else school name
        if userForCell.employer != "" {
            if userForCell.role != "" {
            cell.userSchoolNameLabel.text! = "\(userForCell.role) at \(userForCell.employer)"
            }
            else{
                cell.userSchoolNameLabel.text! = "\(userForCell.employer)"
            }
        }
        
        else{
            cell.userSchoolNameLabel.text! = userForCell.employer
        }
        
        if userForCell.portrait != "" {
            cell.userProfilePicture.image = userForCell.portrait.toImage()
        }
        
        cell.userSchoolNameLabel.text! = userForCell.education
        return cell
    }
    
    // Used so that the size of the cell adjusts to the size of the screen
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    
}
