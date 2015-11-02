//
//  menuView.swift
//  Illini Tower 2.0
//
//  Created by Dominic Vitucci on 10/28/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit
import Parse
import Bolts

class menuView: UIViewController, UIWebViewDelegate

{

    @IBOutlet weak var webView: UIWebView!
    
    var loadingActivity = CozyLoadingActivity()
    
    
    override func loadView()
    {
        
        super.loadView()
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        webView.delegate = self
        
        PFConfig.getConfigInBackgroundWithBlock {
            (var config: PFConfig?, error: NSError?) -> Void in
            if error == nil {
                let menu = config?["menuLink"] as! String
                NSLog("Menu Opened")
                
                let requestURL = NSURL(string: menu)
                
                let request = NSURLRequest(URL: requestURL!)
                
                self.webView.loadRequest(request)
            } else {
                print("Failed to fetch. Using Cached Config.")
                config = PFConfig.currentConfig()
            }
    
//        PFConfig.getConfigInBackgroundWithBlock {
//            (config: PFConfig!, error: NSError!) -> Void in
//            let menu = config["menuLink"] as! String
//                NSLog("Menu Opened")
//                
//                let requestURL = NSURL(string: menu)
//                
//                let request = NSURLRequest(URL: requestURL!)
//                
//                self.webView.loadRequest(request)
            }
        
        let tracker:GAITracker = GAI.sharedInstance().defaultTracker as GAITracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Menu", action: "MenuBeingViewed", label: "Menu", value: nil).build() as [NSObject : AnyObject])
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