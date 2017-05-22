//
//  CoffeeMeetupsViewController + CollectionView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/16/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

// MARK: - UICollectionView extension
extension CoffeeMeetupsVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Upcoming coffee events
        if section == 0 {
            return upComingCoffee.count
        } else {
            return pendingCoffee.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView!
        // Checks if the view for supplementary element is the right type
        if kind == UICollectionElementKindSectionHeader {
            // Assigning reusable view
            reusableView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: "Header",
                for: indexPath
            )
            
            // Accessing the labels
            let label = reusableView?.subviews[0] as! UILabel
            headerTitleLabel = label
            // Header title label is hidden
            // TODO: Make this appear when the cells appear
            // headerTitleLabel?.isHidden = true
            
            // Titles of the sections
            let sectionNames = [
                "Upcoming coffee meetups",
                "Pending coffee invitations"
            ]
            // Assigning the title of the label
            headerTitleLabel?.text = sectionNames[indexPath.section]
            
        }
        
        return reusableView
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var invitationSelected: (coffee: Coffee, user: User)?
        
        // Invitation selected
        if indexPath.section == 0 {
            invitationSelected = upComingCoffee[indexPath.row]
            coffeeSelectedIndex = indexPath.row
            collectionViewSection = indexPath.section
        } else {
            invitationSelected = pendingCoffee[indexPath.row]
            coffeeSelectedIndex = indexPath.row
            collectionViewSection = indexPath.section
        }
        
        if let invitationSelected = invitationSelected {
            // Setting up popover
            setupPopover(with: invitationSelected)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /*
        if titleHidden == true {
            headerTitleLabel?.isHidden = false
            titleHidden = false
        }
        */
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CoffeeMeetupCell",
            for: indexPath) as! CoffeeMeetupCollectionViewCell
        
        var thisData: (coffee: Coffee, user: User)
        
        if indexPath.section == 0 {
            thisData = upComingCoffee[indexPath.row]
        } else {
            thisData = upComingCoffee[indexPath.row]
        }
        
        cell.configure(with: thisData)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout extension
extension CoffeeMeetupsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: view.bounds.width,
            height: view.bounds.height * 0.2
        )
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        /*
        if !collectionView.visibleCells.isEmpty {
            let height = collectionView.visibleCells[0].frame.height
            return height / 2
        }
        */
        
        return 10
    }
    
}
