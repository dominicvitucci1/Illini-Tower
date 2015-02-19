//
//  submitWorkOrder.swift
//  Illini Tower 2.0
//
//  Created by Dominic Vitucci on 10/29/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit

class submitWorkOrder: UIViewController {

    
    @IBOutlet weak var webView: UIWebView!
    
    
    
    var urlPath = "https://portal.campushousing.com/ILLINOIS-Illini-Tower/Default.aspx?Params=L9ezxPcQnQuRGKTzF%2b4sxeNblvAA%2b26c"
    
    
    
    override func loadView() {
        
        super.loadView()
        
        
        
        loadURL()
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var tracker:GAITracker = GAI.sharedInstance().defaultTracker as GAITracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("SubmitWorkOrder", action: "WorkOrderPageOpened", label: "WorkOrder", value: nil).build())
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    func loadURL()
        
    {
        
        let requestURL = NSURL(string: urlPath)
        
        let request = NSURLRequest(URL: requestURL!)
        
        webView.loadRequest(request)
        
        
        
    }
    
}