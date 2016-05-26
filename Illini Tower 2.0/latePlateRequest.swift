//
//  latePlateRequest.swift
//  Illini Tower 2.0
//
//  Created by Dominic Vitucci on 10/30/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit
import MessageUI

class latePlateRequest: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate
    {
    
    @IBOutlet weak var plateName: UITextField!
    
    @IBOutlet weak var plateMeal: UITextField!
    
    @IBOutlet weak var plateEmail: UITextField!
    
    @IBOutlet weak var platePhoneNumber: UITextField!
    
    @IBOutlet weak var plateRoomNumber: UITextField!
    
    @IBOutlet weak var plateFood: UITextField!
    
    @IBOutlet weak var notesView: UITextField!
    
    var toEmail = ""
    var toName = ""
    var messageText = ""
    var subject = ""
    var fromName = ""
    
    
    var kPreferredTextFieldToKeyboardOffset: CGFloat = 55.0
    var keyboardFrame: CGRect = CGRect.null
    var keyboardIsShowing: Bool = false
    weak var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        plateName.delegate = self
        plateMeal.delegate = self
        plateEmail.delegate = self
        platePhoneNumber.delegate = self
        plateRoomNumber.delegate = self
        plateFood.delegate = self

        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(latePlateRequest.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(latePlateRequest.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        for subview in self.view.subviews
        {
            if (subview.isKindOfClass(UITextField))
            {
                let textField = subview as! UITextField
                textField.addTarget(self, action: #selector(latePlateRequest.textFieldDidReturn(_:)), forControlEvents: UIControlEvents.EditingDidEndOnExit)
                
                textField.addTarget(self, action: #selector(UITextFieldDelegate.textFieldDidBeginEditing(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
                
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let alertController = UIAlertController(title: NSLocalizedString("Requests for lunch must be submitted prior to 9am on the day of request. Requests for dinner must be sumbitted prior to 4:30pm on the day of request", comment: ""), message: "", preferredStyle: .Alert)
        
        // Create the actions
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    func keyboardWillShow(notification: NSNotification)
    {
        self.keyboardIsShowing = true
        
        if let info = notification.userInfo {
            self.keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            self.arrangeViewOffsetFromKeyboard()
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        self.keyboardIsShowing = false
        
        self.returnViewToInitialFrame()
    }
    
    func arrangeViewOffsetFromKeyboard()
    {
        let theApp: UIApplication = UIApplication.sharedApplication()
        let windowView: UIView? = theApp.delegate!.window!
        
        let textFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.frame.origin.x, self.activeTextField!.frame.origin.y + self.activeTextField!.frame.size.height)
        
        let convertedTextFieldLowerPoint: CGPoint = self.view.convertPoint(textFieldLowerPoint, toView: windowView)
        
        let targetTextFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.frame.origin.x, self.keyboardFrame.origin.y - kPreferredTextFieldToKeyboardOffset)
        
        let targetPointOffset: CGFloat = targetTextFieldLowerPoint.y - convertedTextFieldLowerPoint.y
        let adjustedViewFrameCenter: CGPoint = CGPointMake(self.view.center.x, self.view.center.y + targetPointOffset)
        
        UIView.animateWithDuration(0.2, animations:  {
            self.view.center = adjustedViewFrameCenter
        })
    }
    
    func returnViewToInitialFrame()
    {
        let initialViewRect: CGRect = CGRectMake(0.0, 60.0, self.view.frame.size.width, self.view.frame.size.height)
        
        if (!CGRectEqualToRect(initialViewRect, self.view.frame))
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame = initialViewRect
            });
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if (self.activeTextField != nil)
        {
            self.activeTextField?.resignFirstResponder()
            self.activeTextField = nil
        }
    }
    
    @IBAction func textFieldDidReturn(textField: UITextField!)
    {
        textField.resignFirstResponder()
        self.activeTextField = nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        self.activeTextField = textField
        
        if(self.keyboardIsShowing)
        {
            self.arrangeViewOffsetFromKeyboard()
        }
   

    
            
        }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    
    
        
        
        
        @IBAction func sendSuggestion(sender: AnyObject)
        {
            if (plateName.text!.isEmpty || plateMeal.text! .isEmpty || plateEmail.text!.isEmpty || platePhoneNumber.text!.isEmpty || plateRoomNumber.text!.isEmpty || plateFood.text!.isEmpty) {
                
                let alertController = UIAlertController(title: NSLocalizedString("Please fill out all required information", comment: ""), message: "", preferredStyle: .Alert)
                
                // Create the actions
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                // Add the actions
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.presentViewController(alertController, animated: true, completion: nil)
            }
                
            else {

            
            let latePlateAlert: UIAlertView = UIAlertView()
            
            latePlateAlert.delegate = self
            
            latePlateAlert.title = "By submitting this form you agree to have 1 meal deducted from your meal plan"
            latePlateAlert.message = "Requests can be picked up between 11am and 1pm for lunch, or between 7pm and 8pm for dinner"
            latePlateAlert.addButtonWithTitle("Cancel")
            latePlateAlert.addButtonWithTitle("Accept")
            
            latePlateAlert.show()
            }
     
        }
    
    func sendMail() {
        
        if (plateName.text!.isEmpty || plateMeal.text! .isEmpty || plateEmail.text!.isEmpty || platePhoneNumber.text!.isEmpty || plateRoomNumber.text!.isEmpty || plateFood.text!.isEmpty) {
            
            let alertController = UIAlertController(title: NSLocalizedString("Please fill out all required information", comment: ""), message: "", preferredStyle: .Alert)
            
            // Create the actions
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            
            // Add the actions
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.presentViewController(alertController, animated: true, completion: nil)
        }
            
        else {
            
            let loadingActivity = CozyLoadingActivity(text: "Sending...", sender: self, disableUI: true)
            
            let name = plateName.text
            let meal = plateMeal.text
            let email = plateEmail.text
            let phoneNumber = platePhoneNumber.text
            let roomNumber = plateRoomNumber.text
            let food = plateFood.text
            let notes = notesView.text
            
            
            var message = "Name: " + name! + "\n" + "Meal: " + meal!
            message += "\n" + "Email: " + email! + "\n" + "Phone Number: " + phoneNumber!
            message += "\n" + "Room Number: " + roomNumber! + "\n" + "Food: " + food!
            message += "\n" + "Additional Notes: " + notes!

            
            messageText = message
            toName = plateName.text!
            toEmail = "dominicvitucci1@gmail.com"
            subject = "Late Plate Request From" + " " + toName
            
            
            PFCloud.callFunctionInBackground("sendEmailTwo", withParameters: ["text": messageText, "toEmail": toEmail, "name": toName, "subject": subject]) {
                (response: AnyObject?, error: NSError?) -> Void in
                let responseString = response as? String
                print(responseString)
                
                if response !== nil {
                    
                    loadingActivity.hideLoadingActivity(success: true, animated: true)
                    
                    let tracker:GAITracker = GAI.sharedInstance().defaultTracker as GAITracker
                    tracker.send(GAIDictionaryBuilder.createEventWithCategory("LatePlateRequest", action: "LatePlateRequested", label: "LatePlateRequest", value: nil).build() as [NSObject : AnyObject])
                    
                    let alertController = UIAlertController(title: "Your late plate request has been sent", message: "Illini Tower thanks you for your request", preferredStyle: .Alert)
                    
                    // Create the actions
                    
                    let cancelAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertActionStyle.Cancel) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                    }
                    
                    // Add the actions
                    alertController.addAction(cancelAction)
                    
                    // Present the controller
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    
                    self.plateName.text = ""
                    self.plateMeal.text = ""
                    self.plateEmail.text = ""
                    self.platePhoneNumber.text = ""
                    self.plateRoomNumber.text = ""
                    self.plateFood.text = ""
                    self.notesView.text = ""
                    
                } else {
                    //  Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }

    
//    let mailComposeViewController = configuredMailComposeViewController()
//    if MFMailComposeViewController.canSendMail() {
//    self.presentViewController(mailComposeViewController, animated: true, completion: nil)
//    }
//    
//    else
//    {
//    self.showSendMailErrorAlert()
//    }
}

//func configuredMailComposeViewController() -> MFMailComposeViewController {
//    let mailComposerVC = MFMailComposeViewController()
//    mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
//    
//    
//    
//    
//    let name = plateName.text
//    let meal = plateMeal.text
//    let email = plateEmail.text
//    let phoneNumber = platePhoneNumber.text
//    let roomNumber = plateRoomNumber.text
//    let food = plateFood.text
//    let notes = notesView.text
//    
//    
//    var message = "Name: " + name! + "\n" + "Meal: " + meal!
//    message += "\n" + "Email: " + email! + "\n" + "Phone Number: " + phoneNumber!
//    message += "\n" + "Room Number: " + roomNumber! + "\n" + "Food: " + food!
//    message += "\n" + "Additional Notes: " + notes!
//    
//    
//    
//    
//    mailComposerVC.setToRecipients(["TheSkillet@illinitower.net"])
//    mailComposerVC.setSubject("Late Plate Request")
//    mailComposerVC.setMessageBody(message, isHTML: false)
//    
//    
//    plateName.text = ""
//    plateMeal.text = ""
//    plateEmail.text = ""
//    platePhoneNumber.text = ""
//    plateRoomNumber.text = ""
//    plateFood.text = ""
//    notesView.text = ""
//    
//    
//    let tracker:GAITracker = GAI.sharedInstance().defaultTracker as GAITracker
//    tracker.send(GAIDictionaryBuilder.createEventWithCategory("LatePlateRequest", action: "LatePlateRequested", label: "LatePlateRequest", value: nil).build() as [NSObject : AnyObject])
//    
//    return mailComposerVC
//    
//    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        
        switch buttonIndex {
            
        case 1:
            self.sendMail()
            NSLog("sent")
            
        default:
            print("alertView \(buttonIndex) clicked")
            
            
        }
        
        
    }

    
//        func showSendMailErrorAlert() {
//            let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
//            sendMailErrorAlert.show()
//        }
//    
//        // MARK: MFMailComposeViewControllerDelegate Method
//        func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
//            controller.dismissViewControllerAnimated(true, completion: nil)
//        }
}

