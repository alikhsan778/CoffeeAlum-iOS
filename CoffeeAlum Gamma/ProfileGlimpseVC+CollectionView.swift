//
//  ProfileGlimpseViewController + CollectionViewCell.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/10/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

extension ProfileGlimpseVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCollectionViewCell
        
        // Setting up the popover source
        popoverPresentationController?.sourceRect = cell.frame
        popoverPresentationController?.sourceView = collectionView
        
        return cell
        
    }
    
    
    
}
