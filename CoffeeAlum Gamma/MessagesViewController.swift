//
//  MessagesViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/8/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

class MessagesViewController: UIViewController {
    
    @IBOutlet weak var listOfMessageCollectionView: UICollectionView!
    
    
    override func viewDidLayoutSubviews() {
        // Method to allow the sidebar to be used
        setupSidebarMenuPanGesture()
    }
    
}

extension MessagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as! MessageCollectionViewCell
        return cell
    }
    
}
