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
        
        if section == 0{
            return upComingCoffee.count
        }
        
        else {
            return pendingCoffee.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Setting up popover
        setupPopover()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoffeeMeetupCell", for: indexPath) as! CoffeeMeetupCollectionViewCell
        
        var thisData:(coffee:Coffee,user:User)
        
        if indexPath.section == 0 {thisData = upComingCoffee[indexPath.row]}
        else                      {thisData = upComingCoffee[indexPath.row]}
        
        cell.nameOfInviter.text = thisData.user.name
        cell.pictureOfInviter.image = thisData.user.portrait.toImage()
        if thisData.user.employer == "" {
            cell.roleOfOther.text = "Student at \(thisData.user.education)"
        }
            
        else{
            cell.roleOfOther.text = "\(thisData.user.role) at \(thisData.user.employer)"
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout extension
extension CoffeeMeetupsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height - 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -50
    }
    
}
