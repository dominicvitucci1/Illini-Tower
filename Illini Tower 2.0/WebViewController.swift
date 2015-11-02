//
//  WebViewController.swift
//  Illini Tower
//
//  Created by Dominic Vitucci on 4/25/15.
//  Copyright (c) 2015 Dominic Vitucci. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var myWebView: UIWebView!
    
    var urlPath = ""
    var loadingActivity = CozyLoadingActivity()
    
    
    
    override func loadView()
    {
        
        super.loadView()
        myWebView.delegate = self
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
    
    func webViewDidStartLoad(_ :UIWebView){
        if (urlPath == "http://instagram.com/IlliniTower") {
            
        }
        else {
        loadingActivity = CozyLoadingActivity(text: "Loading...", sender: self, disableUI: true)
        }
        
    }
    func webViewDidFinishLoad(_ :UIWebView){
        if (urlPath == "http://instagram.com/IlliniTower") {
            
        }
        else {
        loadingActivity.hideLoadingActivity(success: true, animated: true)
        }
    }

}
