//
//  payYourrent.swift
//  Illini Tower
//
//  Created by Dominic Vitucci on 10/28/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//


import UIKit
import WebKit

class payYourRent: UIViewController
{
    
    @IBOutlet weak var webView: UIWebView!
    
    
    
    var urlPath = "https://portal.campushousing.com/ILLINOIS-Illini-Tower/Default.aspx?Params=L9ezxPcQnQuRGKTzF%2b4sxeNblvAA%2b26c"
    
    
    
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