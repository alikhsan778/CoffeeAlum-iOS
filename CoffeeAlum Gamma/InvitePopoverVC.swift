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

protocol InviteDelegate {
    func inviteSent()
}

class InvitePopoverVC: UIViewController {
    
    var viewedUser: User?
    
    var thisUser: User?
    
    var date: String?
    
    var time: String?
    
    var coffee: Coffee?
    
    var coreLocationManager = CLLocationManager()
    
    var currentLocation: CLLocation!
    
    var locationManager: LocationManager!
    
    var location: String?
    
    var locationSet: Bool = false
    
    var resultSearchController: UISearchController? = nil
    
    var selectedPin: MKPlacemark? = nil
    
    var delegate: InviteDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Assigning the delegate to self
        coreLocationManager.delegate = self
        // Setup the map view
        userLocationHelper()
    }
    
    /*
     - Sets the coffee data
     – Sends the information to Firebase
     */
    @IBAction func inviteButtonAction(_ sender: UIButton) {
        if inviteComplete() {
            // This is never called because the location is given
            print("Complete")
            coffee = Coffee(date: dateTextField.text!,
                                time: timeTextField.text!,
                                location: mapView.userLocation.title!,
                                fromId: thisUser!.uid,
                                toId: viewedUser!.uid,
                                fromName: thisUser!.name,
                                toName: viewedUser!.name)
            
            // Saves the meetup data
            self.coffee?.save(new: true)
            // Dismisses the Invite Popover
            self.dismiss(animated: true, completion: nil)
            
        } else {
            print("Incomplete") // Testing
            // TODO: Create warning for incomplete invite
            self.dismiss(animated: true, completion: {
                self.delegate!.inviteSent()
            })
        }
        
    }
    
    /// Method to check if the invitation information is nil or not
    func inviteComplete() -> Bool {
        if let date = dateTextField.text, let time = timeTextField.text, let location = mapView.userLocation.title {
            // TODO: Change the location because this is just a default value
            print(date, time, location)
            return true
        } else {
            return false
        }
    }
}


