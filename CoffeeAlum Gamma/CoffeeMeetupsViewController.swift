//
//  ListOfCoffeeMeetupsViewController.swift
//  CoffeeAlum
//
//  Created by Trevin Wisaksana on 12/26/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit

class CoffeeMeetupsViewController: UIViewController, SWRevealViewControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var headlineLabel: UILabel!
    
    // MARK: - List of Datas
    var listOfBanners = [BannerDataModel]()
    
    // MARK: - User Interaction Properties
    var tapGesture = UITapGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()
    
    // Sidebar button which reveals the side bar
    @IBAction func sidebarMenuButtonAction(_ sender: UIButton) {
        // Connects to the revealToggle method in the SWRevealViewController custom code
        sender.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
    }
    
    
    // MARK: - Mandatory Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Minor adjustment to make the labe adaptize to size

        // Setting up the delegate to work with the button
        self.revealViewController().delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        // Using the Pan Gesture Recognizer to reveal the "SWRevealViewController"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Adjusting the revealWidth so that it works fairly with all screen sizes
        self.revealViewController().rearViewRevealWidth = self.view.frame.width / 3.2
    }
    
    
    
}

// MARK: - UICollectionView extension
extension CoffeeMeetupsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoffeeMeetupCell", for: indexPath) as! CoffeeMeetupCollectionViewCell
        
        return cell
        
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout extension
extension CoffeeMeetupsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height - 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -50
    }
    
}
