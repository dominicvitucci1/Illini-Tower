//
//  myIlliniView.swift
//  Illini Tower
//
//  Created by Dominic Vitucci on 2/19/15.
//  Copyright (c) 2015 Dominic Vitucci. All rights reserved.
//

import UIKit

class myIlliniView: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Screen Tracking for Google Analytcis
        var tracker:GAITracker = GAI.sharedInstance().defaultTracker as GAITracker
        tracker.set(kGAIScreenName, value:"My Illini Tower Screen")
        tracker.send(GAIDictionaryBuilder.createScreenView().build())
        
        //navigationItem.titleView = UIImageView(image: UIImage(named: "Top Bar Test"))


}
}
