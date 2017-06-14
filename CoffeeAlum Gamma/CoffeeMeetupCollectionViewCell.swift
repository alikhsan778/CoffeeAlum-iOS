//
//  BannerCell.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/1/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class CoffeeMeetupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backingView: UIView!
    @IBOutlet weak var nameOfInviter: UILabel!
    @IBOutlet weak var pictureOfInviter: UIImageView!
    @IBOutlet weak var roleOfOther: UILabel!
    
    func configure(with invitation: Invitation) {
        
        nameOfInviter.text = invitation.user.name
        
        // Checks if the user has no employer
        if invitation.user.employer == "" {
            roleOfOther.text = "Student at \(invitation.user.education)"
        } else {
            nameOfInviter.text = "\(invitation.user.role) at \(invitation.user.employer)"
        }
        
        let url = URL(string: invitation.user.portrait)
        pictureOfInviter.sd_setImage(with: url)
    }
    
    override func layoutSubviews() {
        pictureOfInviter.circularize()
    }
    
}

