//
//  SearchViewController + SearchBar.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/9/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Firebase

// Extension that handles the search bar
extension SearchVC: UITextViewDelegate {
    
    // MARK: - Text View Methods
    // Method to filter text as a search bar
    // MARK - Search functions
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            textView.resignFirstResponder()
            
            let lowercaseText = textView.text.lowercased()
            
            let query = userRef.queryOrdered(byChild: "searchName").queryStarting(atValue: lowercaseText).queryEnding(atValue: lowercaseText+"\u{f8ff}").queryLimited(toFirst: 5)
            
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChildren() {
                    
                    for item in snapshot.children {
                        
                        guard let info = item as? FIRDataSnapshot else {
                            break
                        }
                        
                        let searchedUser = User(snapshot: info)
                        
                        self.filteredDataSet.insert(searchedUser)
                        
                    }
                    
                    self.filteredUsers = Array(self.filteredDataSet)
                    self.collectionView.reloadData()
                    
                }
            })
            
            return false
        }
        
        // TODO: Cache the value
        if text.isEmpty {
            filteredUsers.removeAll()
            filteredDataSet.removeAll()
            collectionView.reloadData()
        }
        
        return true
    }
   
    // Method that interferes when user begins to edit text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Checks if the text color is the same
        if textView.textColor == UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 0.5) {
            
            // Erases the placeholder
            textView.text.removeAll()
            textView.textColor? = UIColor.white
            textView.font = textView.font?.withSize(43)
            
        }
    }
    
    // Method where user ends editting the text view
    func textViewDidEndEditing(_ textView: UITextView) {
        // If the user finishes the edit
        if textView.text.isEmpty {
            // Make the placeholder be the same as the original state
            textView.text = "Tap here to search"
            textView.textColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
            textView.font = textView.font?.withSize(43)
        }
    }
}
