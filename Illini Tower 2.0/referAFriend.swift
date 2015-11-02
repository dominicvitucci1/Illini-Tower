//
//  referAFriend.swift
//  Illini Tower 2.0
//
//  Created by Dominic Vitucci on 10/28/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit
import MessageUI
import Foundation

class referAFriend: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate

{

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var roomNumberField: UITextField!
    
    @IBOutlet weak var yourEmailField: UITextField!
    
    @IBOutlet weak var friendsNameField: UITextField!
    
    @IBOutlet weak var friendsEmailField: UITextField!
    
    @IBOutlet weak var friendsMoveInField: UITextField!
    
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
        
        nameField.delegate = self
        roomNumberField.delegate = self
        yourEmailField.delegate = self
        friendsNameField.delegate = self
        friendsEmailField.delegate = self
        friendsMoveInField.delegate = self
        
        
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
        
        
        
        @IBAction func sendRequest(sender: AnyObject)
        {
            
            if (nameField.text!.isEmpty || roomNumberField!.text!.isEmpty || yourEmailField!.text!.isEmpty || friendsNameField!.text!.isEmpty || friendsEmailField!.text!.isEmpty || friendsMoveInField!.text!.isEmpty) {
                
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
                
                let name = nameField.text
                let room = roomNumberField.text
                let yourEmail = yourEmailField.text
                let friendsName = friendsNameField.text
                let friendsEmail = friendsEmailField.text
                let friendsMoveIn = friendsMoveInField.text
                
                var message = "Resident's Name: " + name! + "\n" + "Resident's Room Number: " + room!
                message += "\n" + "Resident's Email: " + yourEmail!
                message += "\n" + "Friend's Name: " + friendsName! + "\n" + "Friend's Email:" + friendsEmail!
                message += "\n" + "Friend's Movie In Date: " + friendsMoveIn!
                
                messageText = message
                toName = nameField.text!
                toEmail = "ben.bytheway@clvusa.com"
                subject = "Refer a Friend From" + " " + toName
                
                
                PFCloud.callFunctionInBackground("sendMail", withParameters: ["text": messageText, "toEmail": toEmail, "name": toName, "subject": subject]) {
                    (response: AnyObject?, error: NSError?) -> Void in
                    let responseString = response as? String
                    print(responseString)
                    
                    if response !== nil {
                        
                        loadingActivity.hideLoadingActivity(success: true, animated: true)
                        
                        let alertController = UIAlertController(title: "Your referral has been sent", message: "Illini Tower thanks you for your referral", preferredStyle: .Alert)
                        
                        // Create the actions
                        
                        let cancelAction = UIAlertAction(title: NSLocalizedString("Okay", comment: ""), style: UIAlertActionStyle.Cancel) {
                            UIAlertAction in
                            NSLog("Cancel Pressed")
                        }
                        
                        // Add the actions
                        alertController.addAction(cancelAction)
                        
                        // Present the controller
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        
                        self.nameField.text = ""
                        self.roomNumberField.text = ""
                        self.yourEmailField.text = ""
                        self.friendsNameField.text = ""
                        self.friendsEmailField.text = ""
                        self.friendsMoveInField.text = ""
                        
                        
                    } else {
                        //  Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }

            
            
//            let mailComposeViewController = configuredMailComposeViewController()
//            if MFMailComposeViewController.canSendMail()
//            {
//                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
//            }
//                
//            else
//            {
//                self.showSendMailErrorAlert()
//            }
        }
        
//        func configuredMailComposeViewController() -> MFMailComposeViewController {
//            let mailComposerVC = MFMailComposeViewController()
//            mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
//            
//            
//            let name = nameField.text
//            let room = roomNumberField.text
//            let yourEmail = yourEmailField.text
//            let friendsName = friendsNameField.text
//            let friendsEmail = friendsEmailField.text
//            let friendsMoveIn = friendsMoveInField.text
//            
//            var message = "Resident's Name: " + name! + "\n" + "Resident's Room Number: " + room!
//            message += "\n" + "Resident's Email: " + yourEmail!
//            message += "\n" + "Friend's Name: " + friendsName! + "\n" + "Friend's Email:" + friendsEmail!
//            message += "\n" + "Friend's Movie In Date: " + friendsMoveIn!
//            
//            
//            
//            mailComposerVC.setToRecipients(["ben.bytheway@clvusa.com"])
//            mailComposerVC.setSubject("Refer A Friend")
//            mailComposerVC.setMessageBody(message, isHTML: false)
//            
//            
//            
//            nameField.text = ""
//            roomNumberField.text = ""
//            yourEmailField.text = ""
//            friendsNameField.text = ""
//            friendsEmailField.text = ""
//            friendsMoveInField.text = ""
//            
//            return mailComposerVC
//            
//            
//            
//            
//        }
//        
//        func showSendMailErrorAlert() {
//            let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
//            sendMailErrorAlert.show()
//        }
        
        // MARK: MFMailComposeViewControllerDelegate Method
        func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
}
}
