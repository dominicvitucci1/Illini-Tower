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

        
        var requestURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("contact_your_ra", ofType: "html")!)

       let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)



   }



}

