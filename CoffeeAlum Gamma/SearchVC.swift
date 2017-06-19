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
    
    private enum State {
        case `default`
        case loading
        case userIsAStudent
        case userIsAnAlum
        case createUser
        case getStartedSuccessful
        case getStartedFailed(as: Error)
    }
    
    private enum `Error` {
        case userNameIsEmpty
        case fieldOfStudyIsEmpty
        case cityAndRegionIsEmpty
        case firebase(Swift.Error)
        case userFailedToBeCreated
    }
    
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
    
    private var state: State = .default {
        didSet {
            didChange(state)
        }
    }
    
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
    // Testing for Firebase
    var name: String!
    var email: String!
    var registeredUserReference: FIRDatabaseReference!
    var education: String!
    var location: String!
    var account: AccountType!
    var uid: String = FIRAuth.auth()!.currentUser!.uid
    
    // MARK: - Overrided Methods
    override func viewDidLoad() {
        state = .loading
        
        let thisUserRef = userRef.child(uid)
        email = FIRAuth.auth()?.currentUser?.email
       
        // Check if user has filled out intro form; Populate the local user object

        thisUserRef.observe(.value, with: { snapshot in
            if !snapshot.hasChild("name"){
                self.setupPopover(view: self.completeProfileView)
            }
            self.thisUser = User(snapshot: snapshot)
        })
        
        // Making the text field recognize the edit
        nameTextField.delegate = self
        studiedInTextField.delegate = self
        cityUserLivesTextField.delegate = self
        
        // Making the text view recongize the edit
        searchTextView.delegate = self
        
        sidebarMenuButtonOutlet.setupSidebarButtonAction(to: self)
    }
    
    // MARK: - IBAction    
    @IBAction func yesButtonAction(_ sender: UIButton) {
        state = .userIsAStudent
    }
    
    @IBAction func noButtonAction(_ sender: UIButton) {
        state = .userIsAnAlum
    }
    
    @IBAction func closePopover(with segue: UIStoryboardSegue) {}
    
    @IBAction func getStartedButtonAction(_ sender: UIButton) {
        state = .createUser
    }
    
    private func didChange(_ state: State) {
        switch state {
        case .loading:
            setupRevealViewController()
        case .userIsAnAlum:
            account = .alum
        case .userIsAStudent:
            account = .student
        case .createUser:
            createUser()
        case .getStartedSuccessful:
            dismissPopover(view: completeProfileView)
        case .getStartedFailed(let error):
            throwWarning(for: error)
        default:
            break
        }
    }
    
    // MARK: - Error Handler
    private func throwWarning(for error: Error) {
        
        var message: String
        let title = "Whoops! Something went wrong."
        let alertController = UIAlertController()
        
        switch error {
        case .userNameIsEmpty:
            message = "Please enter your full name."
        case .fieldOfStudyIsEmpty:
            message = "Please enter your field of study."
        case .cityAndRegionIsEmpty:
            message = "Please enter the city and region you live in."
        case .userFailedToBeCreated:
            message = "User failed to be created. Check your network connection and try again."
        case .firebase(let error):
            message = "\(error.localizedDescription)"
        }
        
        func addAlertControllerTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self,
                action: #selector(alertControllerTapGestureHandler))
            let alertControllerSubview = alertController.view.superview?.subviews[1]
            alertControllerSubview?.isUserInteractionEnabled = true
            alertControllerSubview?.addGestureRecognizer(tapGesture)
        }
        
        alertController.title = title
        alertController.message = message
        
        present(alertController, animated: true) {
            addAlertControllerTapGesture()
        }
    }
    
    @objc private func alertControllerTapGestureHandler() {
        dismiss(animated: true, completion: nil)
    }
    
    private func createUser() {
        
        guard let name = nameTextField.text else {
            state = .getStartedFailed(as: .userNameIsEmpty)
            return
        }
        
        guard let education = studiedInTextField.text else {
            state = .getStartedFailed(as: .fieldOfStudyIsEmpty)
            return
        }
        
        guard let location = cityUserLivesTextField.text else {
            state = .getStartedFailed(as: .cityAndRegionIsEmpty)
            return
        }
        
        thisUser = User(name: name,
                        account: .alum,
                        education: education,
                        location: location,
                        email: email,
                        uid: uid)
        
        guard let user = thisUser else {
            state = .getStartedFailed(as: .userFailedToBeCreated)
            return
        }
        
        APIClient.save(user) { (error) in
            if error != nil {
                self.state = .getStartedFailed(as: .firebase(error!))
            } else {
                self.state = .getStartedSuccessful
            }
        }
    }
    
    // Required for the Popover transition
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
        
    // Makes the status bar hide if the Complete Profile is not complete yet
    override var prefersStatusBarHidden: Bool {
        if userHasCompletedProfileRequirements {
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

