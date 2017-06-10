//
//  ViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/24/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class SignInVC: UIViewController {
    
    @IBOutlet var mainView: SignInVCMainView!

    // MARK: - App Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        mainView.backingView.addPresetCornerRadius()
    }
 
}

