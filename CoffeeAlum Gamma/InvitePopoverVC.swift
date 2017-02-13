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

protocol InviteDelegate{
    func inviteSent()
}

class InvitePopoverVC: UIViewController {
    
    var viewedUser: User?
    
    var thisUser: User?
    
    var date: String?
    
    var time: String?
    
    var coffee: Coffee?
    
    var coreLocationManager = CLLocationManager()
    
    var locationManager: LocationManager!
    
    var location: String?
    
    var locationSet: Bool = false
    
    var resultSearchController: UISearchController? = nil
    
    var selectedPin: MKPlacemark? = nil
    
    var delegate: InviteDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Assigning the delegate to self
        coreLocationManager.delegate = self
        // Setup the map view
        // userLocationHelper()
        setupLocation()
    }
    
    /*
     - Sets the coffee data
     – Sends the information to Firebase
     */
    @IBAction func inviteButtonAction(_ sender: UIButton) {
        if inviteComplete() {
            // Testing
            coffee = Coffee(date: date!,
                                time: time!,
                                location: mapView.userLocation.title!,
                                fromId: thisUser!.uid,
                                toId: viewedUser!.uid,
                                fromName: thisUser!.name,
                                toName: viewedUser!.name)
            
            self.coffee?.save(new: true) // Saves the meetup data
        } else {
            print("Incomplete") // Testing
            // TODO: Create warning for incomplete invite
            self.dismiss(animated: true, completion: {
                self.delegate!.inviteSent()
            })
        }
        
    }
    
    /// Sets the date data
    @IBAction func dateTextField(_ sender: UITextField) {
        date = sender.text
    }
    
    /// Sets the time data
    @IBAction func timeTextField(_ sender: UITextField) {
        time = sender.text
    }
    
    /// Method to check if the invitation information is nil or not
    func inviteComplete() -> Bool {
        if let date = self.date, let time = self.time, let location = self.location {
            print(date, time, location)
            return true
        } else {
            return false
        }
    }
    }


