//
//  InvitationVCMainView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 6/10/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class InvitationVCMainView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var personInvitingLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var declineButtonOutlet: UIButton!
    @IBOutlet var rescheduleView: UIView!
    @IBOutlet weak var rescheduleTextView: UITextView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        profilePicture.addCircularFrame()
    }
    
    func prepareLabelTexts(with data: Invitation) {
        personInvitingLabel.text = data.user.name
        dateAndTimeLabel.text = data.coffee.date
        placeLabel.text = data.coffee.location
    }

    
}
