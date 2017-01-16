//
//  LoginView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/24/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit

// A class that has a background color editable as a gradient.
@IBDesignable class CustomGradientView: UIView {
    // @IBInspectable makes the properties below show on the editor.
    
    // Top Color of the gradient
    @IBInspectable var topColor: UIColor = UIColor.white {
        didSet {
            layoutSubviews()
        }
    }
    
    // Buttom color of the gradient
    @IBInspectable var bottomColor: UIColor = UIColor.black {
        didSet {
            layoutSubviews()
        }
    }
    
    // Gradient by the X axis
    @IBInspectable var gradientX: CGFloat = 0.5 {
        didSet {
            layoutSubviews()
        }
    }
    
    // Gradient by the Y axis
    @IBInspectable var gradientY: CGFloat = 0.5 {
        didSet {
            layoutSubviews()
        }
    }
    
    // Gradient for
    @IBInspectable var gradientEndX: CGFloat = 0.5 {
        didSet {
            layoutSubviews()
        }
    }
    
    // Gradient for
    @IBInspectable var gradientEndY: CGFloat = 0.5 {
        didSet {
            layoutSubviews()
        }
    }
    
    // Creating a gradient layer
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    // Setup for gradient. Called on every IBInspectable.
    override func layoutSubviews() {
        let colors  = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.colors = colors
        gradientLayer.endPoint = CGPoint(x: gradientX, y: gradientY)
        gradientLayer.startPoint = CGPoint(x: gradientEndX, y: gradientEndY)
        self.setNeedsDisplay()
    }
    
}

