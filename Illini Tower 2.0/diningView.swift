//
//  diningView.swift
//  Illini Tower
//
//  Created by Dominic Vitucci on 2/19/15.
//  Copyright (c) 2015 Dominic Vitucci. All rights reserved.
//

import UIKit

class diningView: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Screen Tracking for Google Analytcis
        let tracker:GAITracker = GAI.sharedInstance().defaultTracker as GAITracker
        tracker.set(kGAIScreenName, value:"Dining Screen")
        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
        
        //navigationItem.titleView = UIImageView(image: UIImage(named: "Top Bar Test"))
        
        
    }
}
