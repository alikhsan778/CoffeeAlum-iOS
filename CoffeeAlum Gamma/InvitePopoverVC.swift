//
//  InvitePopoverViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/15/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation
import Firebase
import MapKit

protocol InviteDelegate: class {
    func inviteSent()
}


final class InvitePopoverVC: UIViewController {
    
    // TODO: MAKE FILEPRIVATE
    var viewedUser: User?
    var thisUser: User?
    fileprivate var date: String?
    fileprivate var time: String?
    fileprivate var coffee: Coffee?
    fileprivate var coreLocationManager = CLLocationManager()
    fileprivate var currentLocation: CLLocation!
    fileprivate var locationManager: LocationManager!
    fileprivate var location: String?
    fileprivate var locationSet: Bool = false
    fileprivate var resultSearchController: UISearchController?
    fileprivate var selectedPin: MKPlacemark?

    weak var delegate: InviteDelegate?
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Assigning the delegate to self
        // coreLocationManager.delegate = self
        // Setup the map view
        // userLocationHelper()
    }
    
    /*
     - Sets the coffee data
     – Sends the information to Firebase
     */
    @IBAction func inviteButtonAction(_ sender: UIButton) {
        
        if inviteComplete() {
            // Create coffee
            // MAP VIEW LOCATION IS FOR TESTING
            // replace with this: mapView.userLocation.title!
            coffee = Coffee(date: dateTextField.text!,
                            time: timeTextField.text!,
                            location: "Jakarta, Indonesia",
                            fromId: thisUser!.uid,
                            toId: viewedUser!.uid,
                            fromName: thisUser!.name,
                            toName: viewedUser!.name)
            
            // Saves the meetup data
            self.coffee?.save(new: true)
            
            // TODO: Create warning for incomplete invite
            self.dismiss(animated: true, completion: {
                self.delegate!.inviteSent()
            })
            
        } else {
            print("Incomplete")
        }
    }
    
    /// Method to check if the invitation information is nil or not
    fileprivate func inviteComplete() -> Bool {
        
        if let date = dateTextField.text, let time = timeTextField.text, let location = placeTextField.text {
            // TODO: Change the location because this is just a default value
            print(date, time, location)
            return true
        } else {
            return false
        }
        
    }
}


