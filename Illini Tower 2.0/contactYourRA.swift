//
//  contactYourRA.swift
//  Illini Tower 2.0
//
//  Created by Dominic Vitucci on 11/2/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit



class contactYourRA: UIViewController, UIWebViewDelegate {



    @IBOutlet weak var webView: UIWebView!

    var loadingActivity = CozyLoadingActivity()
    
    override func loadView() {

        super.loadView()


    }



    override func viewDidLoad() {

        super.viewDidLoad()
        webView.delegate = self
        
        PFConfig.getConfigInBackgroundWithBlock {
            (var config: PFConfig?, error: NSError?) -> Void in
            if error == nil {
                let contact = config?["nonAtomicStratLink"] as! String
                NSLog("Contact Page Opened")
                
                self.webView.loadHTMLString(contact, baseURL: nil)

            } else {
                print("Failed to fetch. Using Cached Config.")
                config = PFConfig.currentConfig()
            }

        
//        PFConfig.getConfigInBackgroundWithBlock
//            {
//                (config: PFConfig!, error: NSError!) -> Void in
//                let contact = config["nonAtomicStratLink"] as! String
//                NSLog("Contact Page Opened")
//                
//                self.webView.loadHTMLString(contact, baseURL: nil)
        }
        
        let tracker:GAITracker = GAI.sharedInstance().defaultTracker as GAITracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("ContactYourRA", action: "ContactPageOpened", label: "ContactYourRA", value: nil).build() as [NSObject : AnyObject])


   }
    
    func webViewDidStartLoad(_ :UIWebView){
        loadingActivity = CozyLoadingActivity(text: "Loading...", sender: self, disableUI: true)
        
        
    }
    func webViewDidFinishLoad(_ :UIWebView){
        loadingActivity.hideLoadingActivity(success: true, animated: true)
        
    }


     override func didReceiveMemoryWarning() {

       super.didReceiveMemoryWarning()

   }



}