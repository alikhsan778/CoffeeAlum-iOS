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
    func sendInvitation()
}


final class InvitePopoverVC: UIViewController {
    
    private enum State {
        case `default`
        case loading
        case attemptToSendInvite
        case failedToSendInvitation(as: Error)
        case inviteSentSuccessfully
    }
    
    private enum `Error` {
        case dateIsEmpty
        case locationIsEmpty
        case timeIsEmpty
    }
    
    private var state: State = .default {
        didSet {
            didChange(state)
        }
    }
    
    private func didChange(_ state: State) {
        switch state {
        case .loading:
            break
        case .failedToSendInvitation(let error):
            throwWarning(for: error)
        case .attemptToSendInvite:
            delegate?.sendInvitation()
        default:
            break
        }
    }
    
    
    
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
        state = .loading
        
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
        state = .attemptToSendInvite
        
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
                
            })
            
        } else {
            print("Incomplete")
        }
    }
    
    private func throwWarning(for error: Error) {
        switch error {
        case .dateIsEmpty:
            break
        case .timeIsEmpty:
            break
        case .locationIsEmpty:
            break
        default:
            break
        }
    }
    
    /// Method to check if the invitation information is nil or not
    fileprivate func inviteComplete() -> Bool {
        
        guard let date = dateTextField.text else {
            state = .failedToSendInvitation(as: .dateIsEmpty)
            return false
        }
        
        guard let time = timeTextField.text else {
            state = .failedToSendInvitation(as: .timeIsEmpty)
            return false
        }
        
        guard let location = placeTextField.text else {
            state = .failedToSendInvitation(as: .locationIsEmpty)
            return false
        }
        
        // TODO: Change the location because this is just a default value
        print(date, time, location)
        return true
    }
}


