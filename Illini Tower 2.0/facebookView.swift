//
//  facebookView.swift
//  Illini Tower 2.0
//
//  Created by Dominic Vitucci on 10/28/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit
import WebKit

class facebookView: UIViewController
{
    
    @IBOutlet weak var webView: UIWebView!
    
    
    
    var urlPath = "http://www.facebook.com/illinitower"
    
    
    
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