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
            
            var location1 = CLLocationCoordinate2D(
                latitude: 40.106485,
                longitude: -88.232341
            )
            
            var span1 = MKCoordinateSpanMake(0.01, 0.01)
            var region1 = MKCoordinateRegion(center: location1, span: span1)
            
            map.setRegion(region1, animated: true)
            
            var annotation1 = MKPointAnnotation()
            annotation1.setCoordinate(location1)
            annotation1.title = "Illini Tower"
            annotation1.subtitle = "Champaign, IL"
            
            self.map.addAnnotation(annotation1)
            
            
            var location2 = CLLocationCoordinate2D(
                latitude: 40.108530,
                longitude: -88.229258
            )
            
            
            var annotation2 = MKPointAnnotation()
            annotation2.setCoordinate(location2)
            annotation2.title = "Illini Union Bookstore"
            annotation2.subtitle = "Champaign, IL"
            
            self.map.addAnnotation(annotation2)
            
            
            var location3 = CLLocationCoordinate2D(
                latitude: 40.105945,
                longitude: -88.227198
            )
            
            
            var annotation3 = MKPointAnnotation()
            annotation3.setCoordinate(location3)
            annotation3.title = "Foellinger Auditorium"
            annotation3.subtitle = "Champaign, IL"
            
            self.map.addAnnotation(annotation3)

        }
}