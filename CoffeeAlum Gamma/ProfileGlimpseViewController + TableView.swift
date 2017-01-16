//
//  ProfileGlimpseViewController + TableView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/10/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

// Setting up the Table View
extension ProfileGlimpseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileGlimpseCell") as! ProfileGlimplseCell
        
        let rowContent = mainCells[indexPath.row]
        
        cell.titleLabel.text = rowContent
       
        return cell
    }
    
    private func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10; // space b/w cells
    }
    
}
