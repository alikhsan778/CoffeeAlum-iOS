//
//  UIView + Shadow.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/1/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

extension UIView {
    
    /// Adds a preset shadow effect to a UIView.
    func addPresetShadow() {
        
        // add the shadow to the base view
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 15
        
        // improves performance
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 20).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        // sets to false to allow the shadow to go beyond the UIView
        self.layer.masksToBounds = false
    }
    
}
