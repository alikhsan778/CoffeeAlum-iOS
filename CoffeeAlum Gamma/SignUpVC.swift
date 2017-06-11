//
//  ViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/24/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit


final class SignUpVC: UIViewController {
    
    // VIEW CONTROLLERS KNOW ABOUT ACTIONS
    // VIEW CONTROLLERS KNOW ABOUT STATE CHANGES
    
    /// States of the view controller.
    fileprivate enum State {
        case `default`
        case incorrectPassword
        case signUpFailure(error: Error)
        case signUpSuccess
        case loading
    }
    
    fileprivate var state: State = .default {
        didSet {
            didChangeState(state)
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet var mainView: SignUpVCMainView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    fileprivate func didChangeState(_ state: State) {
        switch state {
        default:
            break
        }
    }
  
}

