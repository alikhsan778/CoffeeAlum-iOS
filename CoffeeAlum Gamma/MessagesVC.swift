//
//  MessagesViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/8/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

class MessagesVC: UIViewController {
    
    @IBOutlet weak var listOfMessageCollectionView: UICollectionView!
    
    override func viewDidLayoutSubviews() {
        // Method to allow the sidebar to be used
        setupSidebarMenuPanGesture()
    }
    
}
