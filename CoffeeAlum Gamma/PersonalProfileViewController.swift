//
//  ProfileViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/2/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Firebase

class PersonalProfileViewController: UIViewController {
    
    var thisUser: User?
//    var tags: [Tag] TODO: Implement tag tracking feature; Add tags to search
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var occupationTextField: UITextField!
    @IBOutlet weak var employerTextField: UITextField!
    @IBOutlet weak var educationalBackgroundTextField: UITextField!
    @IBOutlet weak var personalWebsiteTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var linkedInProfileTextField: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        let thisUserRef = FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid)
        
        thisUserRef.observe(.value, with: { snapshot in
            self.thisUser = User(snapshot: snapshot)
            self.populateFields()
        })
        
    }
    
    func populateFields(){
        addGestures()
        nameTextField.text = thisUser!.name
        emailTextField.text = thisUser!.email
        occupationTextField.text = thisUser!.role
        employerTextField.text  = thisUser!.employer
        educationalBackgroundTextField.text = thisUser!.education
        personalWebsiteTextField.text = thisUser!.website
        bioTextField.text = thisUser!.bio
        linkedInProfileTextField.text = thisUser!.linkedIn
        profilePicture.image = thisUser!.portrait.toImage()
    }
    
    func submitButton(){
        //put nameTextFieldCondition here
        
        thisUser!.name = nameTextField.text ?? ""
        if nameTextField.text!.characters.count < 2 {
            return //TODO: give useful error message
        }
        
        thisUser!.email = emailTextField.text ?? ""
        if !Helper.validate(email: emailTextField.text!){
            return //TODO: give useful error message
        }
        
        thisUser!.role = occupationTextField.text ?? ""
        thisUser!.employer = employerTextField.text ?? ""
        thisUser!.education = educationalBackgroundTextField.text ?? ""
        thisUser!.website = personalWebsiteTextField.text ?? ""
        thisUser!.bio = bioTextField.text ?? ""
        thisUser!.linkedIn = linkedInProfileTextField.text ?? ""
        
        if let image = profilePicture.image {
            thisUser!.portrait = image.toString()
        }
        
        thisUser!.save()
    }
    
    func addGestures(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.profilePicture.addGestureRecognizer(tap)
    }
    
    //TODO: Select Tags View
    
    
    override func viewDidLayoutSubviews() {
        // Using the Pan Gesture Recognizer to reveal the "SWRevealViewController"
        setupSidebarMenuPanGesture()
    }
}


extension PersonalProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imageTapped() {
        let cameraAlert = UIAlertController(title: "Select a source", message: "Where would you like to get your photos from?", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            self.openMedia(source: .camera)
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { action in
            self.openMedia(source: .photoLibrary)
        }
        
        cameraAlert.addAction(cameraAction)
        cameraAlert.addAction(galleryAction)
        
        self.present(cameraAlert, animated: true, completion: nil)
    }
    
    //Open either camera or gallery
    func openMedia(source: UIImagePickerControllerSourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = source
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            if let image =  info[UIImagePickerControllerOriginalImage] as? UIImage{
                self.profilePicture.image = image
            }
        }
    }
}
