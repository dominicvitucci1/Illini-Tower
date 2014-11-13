//
//  whatsNearBy.swift
//  Illini Tower 2.0
//
//  Created by Dominic Vitucci on 10/28/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit
import MapKit

class whatsNearBy: UIViewController {

        
        @IBOutlet weak var map: MKMapView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            var location = CLLocationCoordinate2D(
                latitude: 40.106485,
                longitude: -88.232341
            )
            
            var span = MKCoordinateSpanMake(0.005, 0.005)
            var region = MKCoordinateRegion(center: location, span: span)
            
            map.setRegion(region, animated: true)
            
            var annotation = MKPointAnnotation()
            annotation.setCoordinate(location)
            annotation.title = "Illini Tower"
            annotation.subtitle = "Champaign, IL"
            
            map.addAnnotation(annotation)
        }
}