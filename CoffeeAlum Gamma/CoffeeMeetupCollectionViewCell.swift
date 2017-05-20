//
//  BannerCell.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/1/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

class CoffeeMeetupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backingView: UIView!
    @IBOutlet weak var nameOfInviter: UILabel!
    @IBOutlet weak var pictureOfInviter: UIImageView!
    @IBOutlet weak var roleOfOther: UILabel!
    
    func configure(with coffee: (coffee: Coffee, user: User)) {
        
        nameOfInviter.text = coffee.user.name
        // cell.pictureOfInviter.image = coffee.user.portrait.toImage()
        
        if coffee.user.employer == "" {
            roleOfOther.text = "Student at \(coffee.user.education)"
        } else {
            nameOfInviter.text = "\(coffee.user.role) at \(coffee.user.employer)"
        }
        
    }
    
    override func awakeFromNib() {
        // backingView.addPresetCornerRadius()
    }
}

