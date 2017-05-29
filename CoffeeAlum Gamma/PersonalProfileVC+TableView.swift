//
//  PersonalProfileVC+TableView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 2/8/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

extension PersonalProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let nibFile = UINib(nibName: "PersonalProfileTableViewCell", bundle: nil)
        tableView.register(nibFile, forCellReuseIdentifier: "PersonalProfileCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalProfileCell") as! PersonalProfileTableViewCell
        
        let user = userList[indexPath.row]
        
        cell.configure(with: user)
        cell.delegate = self
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.view.frame.height * 0.8)
    }
    
}
