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
                let contact = config["nonAtomicStratLink"] as String
                NSLog("Yay! The number is %@!", contact)
                
                self.webView.loadHTMLString(contact, baseURL: nil)
        }
        


   }

     override func didReceiveMemoryWarning() {

       super.didReceiveMemoryWarning()

   }



}