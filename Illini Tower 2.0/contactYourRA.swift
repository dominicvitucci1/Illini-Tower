//
//  contactYourRA.swift
//  Illini Tower 2.0
//
//  Created by Dominic Vitucci on 11/2/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit



class contactYourRA: UIViewController {



    @IBOutlet weak var webView: UIWebView!


    



    override func loadView() {

        super.loadView()
        
    



    }



    override func viewDidLoad() {

        super.viewDidLoad()
        
        PFConfig.getConfigInBackgroundWithBlock
            {
                (config: PFConfig!, error: NSError!) -> Void in
                let contact = config["nonAtomicStratLink"] as! String
                NSLog("Contact Page Opened")
                
                self.webView.loadHTMLString(contact, baseURL: nil)
        }
        
        var tracker:GAITracker = GAI.sharedInstance().defaultTracker as GAITracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("ContactYourRA", action: "ContactPageOpened", label: "ContactYourRA", value: nil).build() as [NSObject : AnyObject])


   }

     override func didReceiveMemoryWarning() {

       super.didReceiveMemoryWarning()

   }



}