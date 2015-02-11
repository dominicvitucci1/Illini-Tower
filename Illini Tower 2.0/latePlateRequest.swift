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
    
    
    
    var kPreferredTextFieldToKeyboardOffset: CGFloat = 55.0
    var keyboardFrame: CGRect = CGRect.nullRect
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

        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        for subview in self.view.subviews
        {
            if (subview.isKindOfClass(UITextField))
            {
                var textField = subview as UITextField
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
            self.keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
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
        var theApp: UIApplication = UIApplication.sharedApplication()
        var windowView: UIView? = theApp.delegate!.window!
        
        var textFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.frame.origin.x, self.activeTextField!.frame.origin.y + self.activeTextField!.frame.size.height)
        
        var convertedTextFieldLowerPoint: CGPoint = self.view.convertPoint(textFieldLowerPoint, toView: windowView)
        
        var targetTextFieldLowerPoint: CGPoint = CGPointMake(self.activeTextField!.frame.origin.x, self.keyboardFrame.origin.y - kPreferredTextFieldToKeyboardOffset)
        
        var targetPointOffset: CGFloat = targetTextFieldLowerPoint.y - convertedTextFieldLowerPoint.y
        var adjustedViewFrameCenter: CGPoint = CGPointMake(self.view.center.x, self.view.center.y + targetPointOffset)
        
        UIView.animateWithDuration(0.2, animations:  {
            self.view.center = adjustedViewFrameCenter
        })
    }
    
    func returnViewToInitialFrame()
    {
        var initialViewRect: CGRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)
        
        if (!CGRectEqualToRect(initialViewRect, self.view.frame))
        {
            UIView.animateWithDuration(0.2, animations: {
                self.view.frame = initialViewRect
            });
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
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
    
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    
    
        
        
        
        @IBAction func sendSuggestion(sender: AnyObject)
        {
            
            
            var latePlateAlert: UIAlertView = UIAlertView()
            
            latePlateAlert.delegate = self
            
            latePlateAlert.title = "By submitting this form you agree to have 1 meal deducted from your meal plan"
            latePlateAlert.message = "Requests can be picked up between 11am and 1pm for lunch, or between 7pm and 8pm for dinner"
            latePlateAlert.addButtonWithTitle("Cancel")
            latePlateAlert.addButtonWithTitle("Accept")
            
            latePlateAlert.show()

            
            
            
            
        }
    
    func sendMail() {
    
    let mailComposeViewController = configuredMailComposeViewController()
    if MFMailComposeViewController.canSendMail() {
    self.presentViewController(mailComposeViewController, animated: true, completion: nil)
    }
    
    else
    {
    self.showSendMailErrorAlert()
    }
}

func configuredMailComposeViewController() -> MFMailComposeViewController {
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
    
    
    
    
    let name = plateName.text
    let meal = plateMeal.text
    let email = plateEmail.text
    let phoneNumber = platePhoneNumber.text
    let roomNumber = plateRoomNumber.text
    let food = plateFood.text
    let notes = notesView.text
    
    
    var message = "Name: " + name + "\n" + "Meal: " + meal + "\n" + "Email: " + email + "\n" + "Phone Number: " + phoneNumber + "\n" + "Room Number: " + roomNumber + "\n" + "Food: " + food + "\n" + "Additional Notes: " + notes
    
    
    
    
    mailComposerVC.setToRecipients(["TheSkillet@illinitower.net"])
    mailComposerVC.setSubject("Late Plate Request")
    mailComposerVC.setMessageBody(message, isHTML: false)
    
    
    plateName.text = ""
    plateMeal.text = ""
    plateEmail.text = ""
    platePhoneNumber.text = ""
    plateRoomNumber.text = ""
    plateFood.text = ""
    notesView.text = ""
    
    
    
    
    return mailComposerVC
    
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        
        switch buttonIndex {
            
        case 1:
            self.sendMail()
            NSLog("sent")
            
        default:
            println("alertView \(buttonIndex) clicked")
            
            
        }
        
        
    }

    
        func showSendMailErrorAlert() {
            let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
            sendMailErrorAlert.show()
        }
    
        // MARK: MFMailComposeViewControllerDelegate Method
        func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
}

