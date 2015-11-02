//
//  Suggestions.swift
//  Illini Tower 2.0
//
//  Created by Dominic Vitucci on 10/28/14.
//  Copyright (c) 2014 Dominic Vitucci. All rights reserved.
//

import UIKit
import MessageUI


class Suggestions: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate
{

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailAddressField: UITextField!
    
    @IBOutlet weak var suggestionField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
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
        emailAddressField.delegate = self
        suggestionField.delegate = self
        
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
        
        if (suggestionField.text!.isEmpty) {
            
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
            
            let messageName = nameField.text
            let messageAddress = emailAddressField.text
            let messageSuggestion =  suggestionField.text
            
            var message = "Name: " + messageName! + "\n" + "Email Address: " + messageAddress!
            message += "\n" + "Suggestion: " + messageSuggestion!
            
            messageText = message
            toName = nameField.text!
            toEmail = "info@illinitower.net"
            subject = "Suggestion From" + " " + toName
            
            
            PFCloud.callFunctionInBackground("sendMail", withParameters: ["text": messageText, "toEmail": toEmail, "name": toName, "subject": subject]) {
                (response: AnyObject?, error: NSError?) -> Void in
                let responseString = response as? String
                print(responseString)
                
                if response !== nil {
                    
                    loadingActivity.hideLoadingActivity(success: true, animated: true)
                    
                    let tracker:GAITracker = GAI.sharedInstance().defaultTracker as GAITracker
                    tracker.send(GAIDictionaryBuilder.createEventWithCategory("Suggestions", action: "SuggestionSent", label: "Suggestions", value: nil).build() as [NSObject : AnyObject])
                    
                    let alertController = UIAlertController(title: "Your suggestion has been sent", message: "Illini Tower thanks you for your input", preferredStyle: .Alert)
                    
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
                    self.emailAddressField.text = ""
                    self.suggestionField.text = ""
                    
                    
                } else {
                    //  Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
    
        
//                let mailComposeViewController = configuredMailComposeViewController()
//                if MFMailComposeViewController.canSendMail() {
//                    self.presentViewController(mailComposeViewController, animated: true, completion: nil)
//                }
//                
//                else
//                {
//                    self.showSendMailErrorAlert()
//                }
//            }
//            
//            func configuredMailComposeViewController() -> MFMailComposeViewController {
//                let mailComposerVC = MFMailComposeViewController()
//                mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
//                
//                
//                let messageName = nameField.text
//                let messageAddress = emailAddressField.text
//                let messageSuggestion =  suggestionField.text
//                
//                var message = "Name: " + messageName! + "\n" + "Email Address: " + messageAddress!
//                message += "\n" + "Suggestion: " + messageSuggestion!
//                
//                mailComposerVC.setToRecipients(["info@illinitower.net"])
//                mailComposerVC.setSubject("Suggestion")
//                mailComposerVC.setMessageBody(message, isHTML: false)
//                
//                
//                nameField.text = ""
//                emailAddressField.text = ""
//                suggestionField.text = ""
//                
//                let tracker:GAITracker = GAI.sharedInstance().defaultTracker as GAITracker
//                tracker.send(GAIDictionaryBuilder.createEventWithCategory("Suggestions", action: "SuggestionSent", label: "Suggestions", value: nil).build() as [NSObject : AnyObject])
//                
//                return mailComposerVC
    
                
            }
            
//            func showSendMailErrorAlert() {
//                let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
//                sendMailErrorAlert.show()
//            }
//            
//            // MARK: MFMailComposeViewControllerDelegate Method
//            func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
//                controller.dismissViewControllerAnimated(true, completion: nil)
//            }
        }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


