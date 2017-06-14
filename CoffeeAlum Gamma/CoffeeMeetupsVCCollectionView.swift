//
//  CoffeeMeetupsVCCollectionView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 6/10/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

final class CoffeeMeetupsVCCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables
    private var headerTitleLabel: UILabel?
    private var titleHidden = true
    private var coffeeSelectedIndex: Int?
    private var collectionViewSection: Int?
    public var allCoffee = Set<Invitation>()
    private var refreshController = UIRefreshControl()
    
    // TODO: Getters and setters change it to fitler coffee
    var pendingCoffee: [Invitation] {
        get {
            return Array(allCoffee).filter {
                !$0.coffee.accepted && !$0.coffee.rescheduled
            }
        }
        
        set {
            let invitationSelected = self.pendingCoffee[coffeeSelectedIndex!]
            allCoffee.remove(invitationSelected)
        }
    }
    
    var upcomingCoffee: [Invitation] {
        get {
            return Array(allCoffee).filter {
                $0.coffee.accepted && !$0.coffee.rescheduled
            }
        }
        
        set {
            let invitationSelected = self.upcomingCoffee[coffeeSelectedIndex!]
            allCoffee.remove(invitationSelected)
        }
    }
    
    var rescheduledCoffee: [Invitation] {
        get {
            return Array(allCoffee).filter {
                $0.coffee.rescheduled && !$0.coffee.accepted
            }
        }
        
        set {
            let invitationSelected = self.rescheduledCoffee[coffeeSelectedIndex!]
            allCoffee.remove(invitationSelected)
        }
    }
    
    override func numberOfItems(inSection section: Int) -> Int {
        // Upcoming coffee events
        if section == 0 {
            return upcomingCoffee.count
        } else if section == 1 {
            return pendingCoffee.count
        } else {
            return rescheduledCoffee.count
        }
    }
    
    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        
        let cell = self.dequeueReusableCell(
            withReuseIdentifier: Cell.CoffeeMeetupCell.rawValue,
            for: indexPath) as! CoffeeMeetupCollectionViewCell
        
        var thisData: Invitation
        let section = indexPath.section
        
        if section == 0 {
            thisData = upcomingCoffee[indexPath.row]
        } else if section == 1 {
            thisData = pendingCoffee[indexPath.row]
        } else {
            thisData = rescheduledCoffee[indexPath.row]
        }
        
        cell.configure(with: thisData)
        
        return cell
        
    }
    
    override func selectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionViewScrollPosition) {
        
        var invitationSelected: Invitation?
        
        let section = indexPath?.section
        
        guard let indexPath = indexPath else {
            return
        }
        
        func setupInvitationSelected(with array: [Invitation]) {
            invitationSelected = array[indexPath.row]
            coffeeSelectedIndex = indexPath.row
            collectionViewSection = indexPath.section
        }
        
        // Invitation selected
        if section == 0 {
            setupInvitationSelected(with: upcomingCoffee)
        } else if section == 1 {
            setupInvitationSelected(with: pendingCoffee)
        } else {
            setupInvitationSelected(with: rescheduledCoffee)
        }
        
        if let invitationSelected = invitationSelected {
            // Setting up popover
            // setupPopover(with: invitationSelected)
        }
        
    }
    
    override func supplementaryView(forElementKind elementKind: String, at indexPath: IndexPath) -> UICollectionReusableView? {
        
        var reusableView: UICollectionReusableView!
        // Checks if the view for supplementary element is the right type
        if elementKind == UICollectionElementKindSectionHeader {
            // Assigning reusable view
            reusableView = self.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: "Header",
                for: indexPath
            )
            
            // Accessing the labels
            let label = reusableView?.subviews[0] as! UILabel
            headerTitleLabel = label
            // Header title label is hidden
            // TODO: Make this appear when the cells appear
            // headerTitleLabel?.isHidden = true
            
            // Titles of the sections
            let sectionNames = [
                "Upcoming coffee meetups",
                "Pending coffee invitations",
                "Pending to be rescheduled"
            ]
            // Assigning the title of the label
            headerTitleLabel?.text = sectionNames[indexPath.section]
            
        }
        
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let width = self.viewController?.view.bounds.width else {
            return CGSize(width: 0, height: 0)
        }
        
        guard let height = self.viewController?.view.bounds.height else {
            return CGSize(width: 0, height: 0)
        }
        
        return CGSize(
            width: width * 0.9,
            height: height * 0.2
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       
        return 10
    }
    
}
