//
//  InvitePopoverVC+Location.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 2/9/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit
import MapKit

extension InvitePopoverVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            coreLocationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location:: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
    
    func setupLocation() {
        
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        coreLocationManager.requestWhenInUseAuthorization()
        coreLocationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTableVC") as! LocationSearchTableVC
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
    }
 
    
    
    /// Setup for user location
    /*
    func userLocationHelper() {
        // Creating an instance of the Location Manager
        locationManager = LocationManager.sharedInstance
        // Ask user for authorization to use the location
        let authorization = CLLocationManager.authorizationStatus()
        // Different states of auth
        let notDetermined = CLAuthorizationStatus.notDetermined
        let requestWhenInUsedApproved = coreLocationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))
        // Checks if the NSLocationWhenInUsageDescription is set
        guard let _ = Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUsageDescription")
            else {
                fatalError("User location permission description not set")
        }
        
        // Checks if the user has not authorized the location to be used
        if authorization == notDetermined && requestWhenInUsedApproved {
            // Asks a request for authorization
            coreLocationManager.requestWhenInUseAuthorization()
        } else {
            // Calls getLocation as the user has already authorized location to be used
            // getLocation()
            setupLocation()
        }
        
    }
    
    func getLocation() {
        
        locationManager.startUpdatingLocationWithCompletionHandler { [unowned self](latitude, longitude, status, verboseMessage, error) in
            // Creating an instance of CLLocation
            let location = CLLocation(latitude: latitude,
                                      longitude: longitude)
            // Calls the display method
            self.display(location: location)
        }
    }
    
    func display(location: CLLocation) {
        // Retreving latitude and longitude form the location parameter.
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        // Creating an instance of a CLLocaitionCoordinate2D (used in the coordinateRegion).
        let coordinate2D = CLLocationCoordinate2D(latitude: latitude,
                                                  longitude: longitude)
        // 0.05 is the amount of north-to-south or east-to-west distance (measured in degrees) to use for the span.
        let coordinateSpan = MKCoordinateSpanMake(0.05, 0.05)
        let coordinateRegion = MKCoordinateRegion(center: coordinate2D,
                                                  span: coordinateSpan)
        // Sets the region of the map
        mapView.setRegion(coordinateRegion,
                          animated: true)
        
        // Pin location on the map
        let pinLocationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        // Creating a pin
        let annotation = MKPointAnnotation()
        // Assigning the coordinate of the pin
        annotation.coordinate = pinLocationCoordinate
        // Adding the annotation to the mapView
        mapView.addAnnotation(annotation)
        // Showing the annotation and storing it in an array
        mapView.showAnnotations([annotation], animated: true)
    }
    
    // Method to keep track of the authorization of the user location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // States of authorization
        let notDetermined = CLAuthorizationStatus.notDetermined
        let denied = CLAuthorizationStatus.denied
        let restricted = CLAuthorizationStatus.restricted
        // Checks if denied, notDetermined or restricted
        if status != notDetermined || status != denied || status != restricted {
            getLocation()
        }
        
    }
    */
    
}
