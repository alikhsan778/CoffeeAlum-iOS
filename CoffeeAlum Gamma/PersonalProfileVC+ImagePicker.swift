//
//  PersonalProfileVC+ImagePicker.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 2/8/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit

// Responsible for Image picker when the user wants to edit the profile picture
extension PersonalProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imageTapped() {
        
        let cameraAlert = UIAlertController(title: "Select a source", message: "Where would you like to get your photos from?", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.openMedia(source: .camera)
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.openMedia(source: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            cameraAlert.dismiss(animated: true, completion: nil)
        }
        
        cameraAlert.addAction(cameraAction)
        cameraAlert.addAction(galleryAction)
        cameraAlert.addAction(cancelAction)
        
        self.present(cameraAlert, animated: true, completion: nil)
    }
    
    // Open either camera or gallery
    func openMedia(source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = source
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            
            if let image =  info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                self.profilePicture.image = image
                self.profilePicture.layer.cornerRadius = self.profilePicture.frame.width / 2
                
                // TODO: Firebase request
                APIClient.saveUserProfilePicture(with: image)
                
            }
        }
    }
}

