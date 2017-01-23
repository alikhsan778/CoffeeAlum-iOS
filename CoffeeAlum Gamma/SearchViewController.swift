//
//  SearchViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/31/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Firebase

class SearchViewController: UIViewController, UITextViewDelegate, SWRevealViewControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    
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
    
    
    // MARK: - IBAction
    @IBAction func revealSidebarMenuButtonAction(_ sender: UIButton) {
        // Reveals the sidebar menu
        sender.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
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
        
        if (nameCondition == true) && (studyInCondition == true) && (locationCondition == true) {
            
            //Build a user object
            name = nameTextField.text
            education = studiedInTextField.text
            location = cityUserLivesTextField.text
            
            
            self.thisUser = User(name: name, account: .alum, education: education, location: location)
            thisUser!.save()
            
            
            // Deinitializes the observer
            adaptiveKeyboard.unregisterKeyboardNotifications()
  
            dismissPopover(view: completeProfileView)
        }
        
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////
    
    
    // MARK: - Miscellaneous Properties
    // Creating an instance of Firebase Database reference 
    var ref: FIRDatabaseReference!
    var userRef: FIRDatabaseReference = FIRDatabase.database().reference(withPath: "users")
    
    
    // Used to push the text field away from the keyboard to prevent keyboard overlapping
    var adaptiveKeyboard: AdaptiveKeyboard!
    
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
    var education: String!
    var location: String!
    var account: AccountType!
    var uid: String = FIRAuth.auth()!.currentUser!.uid
    
    // MARK: - Overrided Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Prevents the user form being able to scroll the view
        completeProfileScrollView.isScrollEnabled = false
        
        // Creating an instance of the SignUpSignInKeboardAdaptiveness class
        adaptiveKeyboard = AdaptiveKeyboard(scrollView: completeProfileScrollView, textField: nameTextField, studiedInTextField, cityUserLivesTextField, pushHeight: 80)
        
        // Register keyboard notifications before the view appears
        adaptiveKeyboard.registerKeyboardNotifications()
        
    }
    
    
    override func viewDidLoad() {
        let thisUserRef = userRef.child(FIRAuth.auth()!.currentUser!.uid)
       
        //Check if user has filled out intro form; Populate the local user object

        thisUserRef.observe(.value, with: { snapshot in
            if !snapshot.hasChild("name"){
                self.setupPopover(view: self.completeProfileView)
            }
            self.thisUser = User(snapshot: snapshot)
        })
     
        
        
        // Sets up the reveal view controller for sidebar menu
        revealViewControllerSetup()
        
        // Making the text field recognize the edit
        nameTextField.delegate = self
        studiedInTextField.delegate = self
        cityUserLivesTextField.delegate = self
        
        // Making the text view recongize the edit
        searchTextView.delegate = self
        
        // Setting up the delegate to work with the button
        self.revealViewController().delegate = self
        
        // Creating a placeholder manually in text view
        searchTextView.text = "Tap here to search"
        searchTextView.textColor = UIColor(colorLiteralRed: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        
        // Assigning effect to store the blur effect
        self.blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Setup for popover
//        setupPopover(view: completeProfileView)
    }
    
    // MARK: RevealViewController Setup
    func revealViewControllerSetup() {
        // Using the Pan Gesture Recognizer to reveal the "SWRevealViewController"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Adjusting the revealWidth so that it works fairly with all screen sizes
        self.revealViewController().rearViewRevealWidth = self.view.frame.width / 3.2
        
        // Initializing the screen menu position
        self.revealViewController().frontViewPosition = FrontViewPosition.left
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
    
    func setViewsForUser(){
        
    }
    
    
}

