//
//  whatsNearBy.swift
//  Illini Tower 2.0
//
//  Created by Dominic Vitucci on 10/28/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit
import MapKit

class whatsNearBy: UIViewController, MKMapViewDelegate {

        
        @IBOutlet weak var map: MKMapView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            map.delegate = self
            
            let initialLocation = CLLocationCoordinate2D(
                latitude: 40.106485,
                longitude: -88.232341
            )
            
            let span1 = MKCoordinateSpanMake(0.01, 0.01)
            let region1 = MKCoordinateRegion(center: initialLocation, span: span1)
            
            map.setRegion(region1, animated: true)
            
            annotate()
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        NSLog("viewForannotation")
        if annotation is MKUserLocation {
            //return nil
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            //println("Pinview was nil")
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        
        let button = UIButton(type: UIButtonType.DetailDisclosure) // button with info sign in it
        
        pinView?.rightCalloutAccessoryView = button
        
        
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
            let location = view.annotation as! Point
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
    
    
    
    func annotate() {
        
        // show point on map
        let point1 = Point(title: "Illini Tower",
            locationName: "409 East Chalmers Street, Champaign, IL 61820",
            discipline: "",
            coordinate: CLLocationCoordinate2D(latitude: 40.106485, longitude: -88.232341))
        
        map.addAnnotation(point1)
        
        
        let point2 = Point(title: "Illini Union Bookstore",
            locationName: "809 South Wright Street, Champaign, IL 61820",
            discipline: "",
            coordinate: CLLocationCoordinate2D(latitude: 40.108530, longitude: -88.229258))
        
        map.addAnnotation(point2)
        
        
        let point3 = Point(title: "Foellinger Auditorium",
            locationName: "709 South Mathews Avenue, Urbana, IL 61801",
            discipline: "",
            coordinate: CLLocationCoordinate2D(latitude: 40.105945, longitude: -88.227198))
        
        map.addAnnotation(point3)
        
        let point4 = Point(title: "Champaign-Urbana MTD Bus Stop",
        locationName: "Corner of Fourth Street and Chalmers Street",
        discipline: "",
        coordinate: CLLocationCoordinate2D(latitude: 40.106867, longitude: -88.233317))
        
        map.addAnnotation(point4)
        
    }

}