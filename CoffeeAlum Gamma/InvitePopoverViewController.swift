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
        } else{return false}
    }
}

// Location settings
extension InvitePopoverViewController : MKMapViewDelegate {
    
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        // Set up selected pin for map
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        
        //Drive Callout Button
        let driveButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        
        driveButton.setBackgroundImage(UIImage(named: "car"), for: .normal)
        driveButton.addTarget(self, action: "getDirections", for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = driveButton
        
        //Set Meeting Location Button
        let setLocationButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        setLocationButton.setBackgroundImage(UIImage(named: "car"), for: .normal)
        setLocationButton.addTarget(self, action: "setLocation", for: .touchUpInside)
        
        if !locationSet{
            pinView?.rightCalloutAccessoryView = setLocationButton
        }
        return pinView
    }
    
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    func setLocation(){
        locationSet = true
        self.location = selectedPin!.title! + "," + selectedPin!.subtitle!
        // TODO: update location label here
        mapView.reloadInputViews()
    }
}



extension InvitePopoverViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location:: (location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
}
