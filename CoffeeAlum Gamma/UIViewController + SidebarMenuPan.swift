//
//  UIViewController + SideMenu Slide.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/9/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func setupRevealViewController() {
        
        // Setting up the delegate to work with the button
        self.revealViewController().delegate = self as? SWRevealViewControllerDelegate
        
        // Using the Pan Gesture Recognizer to reveal the "SWRevealViewController"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Adjusting the revealWidth so that it works fairly with all screen sizes
        self.revealViewController().rearViewRevealWidth = self.view.frame.width / 3.2
        
        // Initializing the screen menu position
        self.revealViewController().frontViewPosition = FrontViewPosition.left
    }
    
}
