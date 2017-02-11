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
    
    override func awakeFromNib() {
        // backingView.addPresetCornerRadius()
    }
}

