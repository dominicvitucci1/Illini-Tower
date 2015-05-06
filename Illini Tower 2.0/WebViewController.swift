//
//  WebViewController.swift
//  Illini Tower
//
//  Created by Dominic Vitucci on 4/25/15.
//  Copyright (c) 2015 Dominic Vitucci. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet var myWebView: UIWebView!
    
    var urlPath = ""
    
    
    
    override func loadView()
    {
        
        super.loadView()
        
        loadURL()
    }
    
    
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
    }
    
    
    
    override func didReceiveMemoryWarning()
    {
        
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func getCurrentUrl(sender: AnyObject)
    {
        let currentURL : NSString = (myWebView.request?.URL!.absoluteString)!
        
        NSLog(currentURL as String)
    }
    
    
    func loadURL()
        
    {
        let requestURL = NSURL(string: urlPath)
        
        let request = NSURLRequest(URL: requestURL!)
        
        myWebView.loadRequest(request)
    }
}
