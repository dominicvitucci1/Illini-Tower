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
        let tracker:GAITracker = GAI.sharedInstance().defaultTracker as GAITracker
        tracker.set(kGAIScreenName, value:"My Illini Tower Screen")
        tracker.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject : AnyObject])
        
        //navigationItem.titleView = UIImageView(image: UIImage(named: "Top Bar Test"))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "workOrder" {
            
            if let destinationVC = segue.destinationViewController as? WebViewController
            {
                destinationVC.urlPath = "https://portal.campushousing.com/ILLINOIS-Illini-Tower/Default.aspx?Params=L9ezxPcQnQuRGKTzF%2b4sxeNblvAA%2b26c" as String
            }
            
            
        }
            
        else if segue.identifier == "review" {
            
            if let destinationVC = segue.destinationViewController as? WebViewController
            {
                destinationVC.urlPath = "https://plus.google.com/+IlliniTower/posts" as String
                
                //https://plus.google.com/local/Champaign%2C%20IL/s/Illini%20Tower
            }
        }

        
    }
}
