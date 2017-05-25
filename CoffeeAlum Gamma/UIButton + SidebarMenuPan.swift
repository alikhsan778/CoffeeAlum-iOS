//
//  UIButton + SidebarMenuPan.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 5/25/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

extension UIButton {
    
    func setupSidebarMenuButton(to viewController: UIViewController) {
        // Connects to the revealToggle method in the SWRevealViewController custom code
        self.addTarget(
            viewController.revealViewController(),
            action: #selector(SWRevealViewController.revealToggle(_:)),
            for: .touchUpInside
        )
    }
    
}
