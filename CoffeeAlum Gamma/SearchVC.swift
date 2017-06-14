//
//  SearchViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/31/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn


final class SearchVC: UIViewController, UITextViewDelegate, SWRevealViewControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var completeProfileScrollView: UIScrollView!
    @IBOutlet weak var searchTextView: UITextView!
    @IBOutlet var completeProfileView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var studiedInTextField: UITextField!
    @IBOutlet weak var cityUserLivesTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var studiedInLabel: UILabel!
    @IBOutlet weak var cityLocationLabel: UILabel!
    @IBOutlet weak var areYouAStudentLabel: UILabel!
    @IBOutlet weak var sidebarMenuButtonOutlet: UIButton!
    

    ////////////////////////////////////////////
    
    // MARK: - Miscellaneous Properties
    // Creating an instance of Firebase Database reference 
    var ref: FIRDatabaseReference!
    var userRef: FIRDatabaseReference = FIRDatabase.database().reference(withPath: "users")
    
    
    // Creating an instance of each class
    var thisUser: User?

    // Animation object
    var blurEffect: UIBlurEffect!
    var blurEffectView: UIVisualEffectView!
    
    // MARK: - Search Objects
    var filteredDataSet = Set<User>()
    var filteredUsers: [User] = []

    // Filtered Users
    
    // MARK: - Lists of Data
    // Search data list for te Collection View
    
    // User profile list for the cell
    
    // Testing for Firebase
    var name: String!
    var email: String!
    var registeredUserReference: FIRDatabaseReference!
    var education: String!
    var location: String!
    var account: AccountType!
    var uid: String = FIRAuth.auth()!.currentUser!.uid
    
    
    // MARK: - Overrided Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Prevents the user form being able to scroll the view
        completeProfileScrollView.isScrollEnabled = false
    }
    
    
    override func viewDidLoad() {
        
        let thisUserRef = userRef.child(uid)
        email = FIRAuth.auth()?.currentUser?.email
       
        // Check if user has filled out intro form; Populate the local user object

        thisUserRef.observe(.value, with: { snapshot in
            if !snapshot.hasChild("name"){
                self.setupPopover(view: self.completeProfileView)
            }
            self.thisUser = User(snapshot: snapshot)
        })
     
        // Sets up the reveal view controller for sidebar menu
        self.setupRevealViewController()
        
        // Making the text field recognize the edit
        nameTextField.delegate = self
        studiedInTextField.delegate = self
        cityUserLivesTextField.delegate = self
        
        // Making the text view recongize the edit
        searchTextView.delegate = self
        
        // Creating a placeholder manually in text view
        searchTextView.text = "Tap here to search"
        searchTextView.textColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        
        // Assigning effect to store the blur effect
        self.blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        sidebarMenuButtonOutlet.setupSidebarButtonAction(to: self)
    }
    
    // MARK: - IBAction
    @IBAction func revealSidebarMenuButtonAction(_ sender: UIButton) {
        
        
    }
    
    @IBAction func yesButtonAction(_ sender: UIButton) {
        // Assigns the user as a student
        self.account = .student
    }
    
    @IBAction func noButtonAction(_ sender: UIButton) {
        // Assigns the user as an alumnus
        self.account = .alum
    }
    
    @IBAction func closePopover(with segue: UIStoryboardSegue) {}
    
    @IBAction func getStartedButtonAction(_ sender: UIButton) {
        
        let nameCondition = checkIfTextFieldHasBeenFilled(for: nameTextField, showStatusIn: usernameLabel)
        let studyInCondition = checkIfTextFieldHasBeenFilled(for: studiedInTextField, showStatusIn: studiedInLabel)
        let locationCondition = checkIfTextFieldHasBeenFilled(for: cityUserLivesTextField, showStatusIn: cityLocationLabel)
        
        // TODO: Change name convention to "is.."
        if (nameCondition == true) && (studyInCondition == true) && (locationCondition == true) {
            
            // Build a user object
            name = nameTextField.text
            education = studiedInTextField.text
            location = cityUserLivesTextField.text
            
            thisUser = User(
                name: name,
                account: .alum,
                education: education,
                location: location,
                email: email,
                uid: uid
            )
            
            thisUser!.save()
            dismissPopover(view: completeProfileView)
        }
        
    }
    
    // Required for the Popover transition
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
        
    // Makes the status bar hide if the Complete Profile is not complete yet
    override var prefersStatusBarHidden: Bool {
        if userHasCompletedProfileRequirements == true {
            return false
        } else {
            return true
        }
    }
    
    // Makes the status bar appearence be animated
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
}

