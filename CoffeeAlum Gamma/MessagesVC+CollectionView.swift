//
//  MessagesVC+CollectionView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 2/11/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

extension MessagesVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCollectionViewCell
        return cell
    }
    
}

