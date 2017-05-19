//
//  CollectionViewCell + CornerRadius .swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/1/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

extension UIView {
    
    /// Adds a preset corner radius to a UIView.
    func addPresetCornerRadius() {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    
}
    
