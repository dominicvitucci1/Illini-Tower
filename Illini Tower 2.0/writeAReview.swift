//
//  writeAReview.swift
//  Illini Tower 2.0
//
//  Created by Dominic Vitucci on 10/29/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit

class writeAReview: UIViewController {

    
        @IBOutlet weak var webView: UIWebView!
        
        
        
        var urlPath = "https://plus.google.com/local/Champaign%2C%20IL/s/Illini%20Tower"
        
        
        
        override func loadView() {
            
            super.loadView()
            
            
            
            loadURL()
            
        }
        
        
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            
            
            
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