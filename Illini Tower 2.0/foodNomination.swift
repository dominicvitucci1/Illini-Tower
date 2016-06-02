//
//  foodNomination.swift
//  Illini Tower 2.0
//
//  Created by Dominic Vitucci on 10/30/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit
import MessageUI
import Parse
import Bolts


class foodNomination: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate
{
    
    @IBOutlet weak var nameNomination: UITextField!
    
    @IBOutlet weak var roomNumberNomination: UITextField!
    
    @IBOutlet weak var foodNomination: UITextField!
    
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
        
        
        nameNomination.delegate = self
        roomNumberNomination.delegate = self
        foodNomination.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        for subview in self.view.subviews
        {
            if (subview.isKindOfClass(UITextField))
            {
                let textField = subview as! UITextField
                textField.addTarget(self, action: "textFieldDidReturn:", forControlEvents: UIControlEvents.EditingDidEndOnExit)
                
                textField.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingDidBegin)
                
            }
        }
        
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
        
        if (nameNomination.text!.isEmpty || roomNumberNomination.text! .isEmpty || foodNomination.text!.isEmpty) {
            
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
        
        let name = nameNomination.text
        let room = roomNumberNomination.text
        let food = foodNomination.text
        
        
        var message = "Name: " + name! + "\n" + "Room Number: " + room!
        message += "\n" + "Nominated Food: " + food!
        
        messageText = message
        toName = nameNomination.text!
        toEmail = "TheSkillet@illinitower.net"
        subject = "Food Nomination From" + " " + toName

        
        PFCloud.callFunctionInBackground("sendEmailTwo", withParameters: ["text": messageText, "toEmail": toEmail, "name": toName, "subject": subject]) {
            (response: AnyObject?, error: NSError?) -> Void in
            let responseString = response as? String
            print(responseString)
            
            if response !== nil {
                
                loadingActivity.hideLoadingActivity(success: true, animated: true)
                
                let alertController = UIAlertController(title: "Your nomination has been sent", message: "Illini Tower thanks you for your input", preferredStyle: .Alert)
                
                // Create the actions
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                // Add the actions
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.presentViewController(alertController, animated: true, completion: nil)
                
                
                self.nameNomination.text = ""
                self.roomNumberNomination.text = ""
                self.foodNomination.text = ""
            
            
            } else {
            //  Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        }
        
//        let mailComposeViewController = configuredMailComposeViewController()
//        if MFMailComposeViewController.canSendMail() {
//            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
//        }
//            
//        else
//        {
//            self.showSendMailErrorAlert()
//        }
//    }
//    
//    func configuredMailComposeViewController() -> MFMailComposeViewController {
//        let mailComposerVC = MFMailComposeViewController()
//        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
//        
//        let name = nameNomination.text
//        let room = roomNumberNomination.text
//        let food = foodNomination.text
//        
//        
//        
//        
//        var message = "Name: " + name! + "\n" + "Room Number: " + room!
//        message += "\n" + "Nominated Food: " + food!
//        
//        
//        mailComposerVC.setToRecipients(["TheSkillet@illinitower.net"])
//        mailComposerVC.setSubject("Food Nomination")
//        mailComposerVC.setMessageBody(message, isHTML: false)
//        
//        nameNomination.text = ""
//        roomNumberNomination.text = ""
//        foodNomination.text = ""
//        
//        return mailComposerVC
//        
        
    }
    
//    func showSendMailErrorAlert() {
//        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
//        sendMailErrorAlert.show()
//    }
//    
//    // MARK: MFMailComposeViewControllerDelegate Method
//    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
//        controller.dismissViewControllerAnimated(true, completion: nil)
//    }
}
