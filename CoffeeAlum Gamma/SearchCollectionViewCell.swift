//
//  SearchCollectionViewCell.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/31/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import Foundation

final class SearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var userNameLabelOutlet: UILabel!
    @IBOutlet weak var userSchoolNameLabel: UILabel!
    @IBOutlet weak var userCityLocationLabel: UILabel!
    @IBOutlet weak var studentOrAlumLabel: UILabel!
    @IBOutlet weak var studentOrAlumView: UIView!
    @IBOutlet weak var userProfilePicture: UIImageView!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
    }
    
}

