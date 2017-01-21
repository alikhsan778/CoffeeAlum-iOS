//
//  ProfileViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/2/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

class PersonalProfileViewController: UIViewController {
    
    var user: User?
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
    
    @IBAction func sideBarMenuButton(_ sender: UIButton) {
        // Connects to the revealToggle method in the SWRevealViewController custom code
        sender.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    }
    
    
    override func viewDidLoad() {
        addGestures()
        nameTextField.text = user!.name
        emailTextField.text = user!.email
        occupationTextField.text = user!.role
        employerTextField.text  = user!.employer
        educationalBackgroundTextField.text = user!.education
        personalWebsiteTextField.text = user!.website
        bioTextField.text = user!.bio
        linkedInProfileTextField.text = user!.linkedIn
        profilePicture.image = user!.portrait.toImage()
    }
    
    func submitButton(){
        //put nameTextFieldCondition here
        
        user!.name = nameTextField.text ?? ""
        if nameTextField.text!.characters.count < 2 {
            return //TODO: give useful error message
        }
        
        user!.email = emailTextField.text ?? ""
        if !Helper.validate(email: emailTextField.text!){
            return //TODO: give useful error message
        }
        
        user!.role = occupationTextField.text ?? ""
        user!.employer = employerTextField.text ?? ""
        user!.education = educationalBackgroundTextField.text ?? ""
        user!.website = personalWebsiteTextField.text ?? ""
        user!.bio = bioTextField.text ?? ""
        user!.linkedIn = linkedInProfileTextField.text ?? ""
        
        if let image = profilePicture.image {
            user!.portrait = image.toString()
        }
        
        user!.save()
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
