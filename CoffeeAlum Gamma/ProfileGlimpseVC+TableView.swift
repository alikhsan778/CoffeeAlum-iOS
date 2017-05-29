//
//  ProfileGlimpseViewController + TableView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/10/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

// Setting up the Table View
extension ProfileGlimpseVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileGlimpseCell") as! ProfileGlimplseCell
        
        let rowHeader = filteredCells[indexPath.row]
        
        cell.titleLabel.text = rowHeader
        cell.infoLabel.text = infoForCell(info: rowHeader)
        cell.infoLabel.isHidden = !data[indexPath.row].expanded

        return cell
    }
    
    func infoForCell(info: String) -> String {
        
        guard let userViewed = userViewed else {
            return ""
        }
        
        switch info{
        case "About":
            return userViewed.bio
        case "Education":
            return userViewed.education
        case "LinkedIn":
            return userViewed.linkedIn
        case "Website":
            return userViewed.website
        default:
            return userViewed.linkedIn
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if infoForCell(info: data[indexPath.row].header) != "" {
            self.data[indexPath.row].1 = !self.data[indexPath.row].1
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if data[indexPath.row].expanded{
            if indexPath.row == 1 {
                return UITableViewAutomaticDimension
            } else {
                return UITableViewAutomaticDimension
            }
        } else {
            return 100
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    private func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 // space b/w cells
    }
}
