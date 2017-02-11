//
//  InvitePopoverVC+MapView.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 2/9/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import UIKit
import MapKit

// Location settings
extension InvitePopoverViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
