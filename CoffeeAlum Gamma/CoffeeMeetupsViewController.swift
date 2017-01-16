//
//  ListOfCoffeeMeetupsViewController.swift
//  CoffeeAlum
//
//  Created by Trevin Wisaksana on 12/26/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit

class CoffeeMeetupsViewController: UIViewController, SWRevealViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var headlineLabel: UILabel!
    
    // MARK: - List of Datas
    var listOfBanners = [BannerDataModel]()
    
    var testData = ["Test"]
    
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

