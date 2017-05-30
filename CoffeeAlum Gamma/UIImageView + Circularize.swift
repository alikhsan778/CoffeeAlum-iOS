//
//  UIImageView + Circularize.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 5/30/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func circularize() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
}
