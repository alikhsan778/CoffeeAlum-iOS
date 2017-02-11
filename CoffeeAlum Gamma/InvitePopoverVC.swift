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

class InvitePopoverViewController: UIViewController {
    
    var viewedUser: User?
    var thisUser: User?
    var date: String?
    var time: String?
    
    var location: String?
    var locationSet: Bool = false
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    var delegate: InviteDelegate?
    
    @IBOutlet weak var mapView: MKMapView! // TODO: Connect here
    
    
    @IBAction func inviteButtonAction(_ sender: UIButton) {
        if inviteComplete(){
            let coffee = Coffee(date: date!, time: time!, location: location!
                , fromId: thisUser!.uid, toId: viewedUser!.uid, fromName: thisUser!.name, toName: viewedUser!.name)
            coffee.save(new: true)
        }
        
        else{
            // TODO: Create warning for incomplete invite
            self.dismiss(animated: true, completion: {
                self.delegate!.inviteSent()
            })
        }
        
        
        
    }
    
    @IBAction func dateTextField(_ sender: UITextField) {
        
    }
    
    @IBAction func timeTextField(_ sender: UITextField) {
        
    }
    
    override func viewDidLoad() {
        
        
    }
    
    func inviteComplete() -> Bool{
        if let date = self.date, let time = self.time, let location = self.location {
            return true
        } else { return false }
    }
}


