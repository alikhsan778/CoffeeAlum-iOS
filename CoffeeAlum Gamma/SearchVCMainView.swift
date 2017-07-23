//
//  SearchVCMainView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 6/15/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

final class SearchVCMainView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var completeProfileScrollView: UIScrollView!
    @IBOutlet weak var searchTextView: UITextView!
    @IBOutlet var completeProfileView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var studiedInTextField: UITextField!
    @IBOutlet weak var cityUserLivesTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var studiedInLabel: UILabel!
    @IBOutlet weak var cityLocationLabel: UILabel!
    @IBOutlet weak var areYouAStudentLabel: UILabel!
    @IBOutlet weak var sidebarMenuButtonOutlet: UIButton!
    
    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var blurEffectView: UIVisualEffectView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addBlurEffect()
    }
    
    func addBlurEffect() {
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func disableScrolling() {
        // Prevents the user from being able to scroll the view
        completeProfileScrollView.isScrollEnabled = false
    }
}
