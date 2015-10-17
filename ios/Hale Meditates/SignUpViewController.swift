//
//  SignUpViewController.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 6/10/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var birthdayTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let picker =  UIDatePicker();
        picker.date = NSDate(timeIntervalSinceNow: NSTimeInterval(-13 * 365 * 24 * 60 * 60));
        picker.datePickerMode = UIDatePickerMode.Date;
        picker.addTarget(self, action: "dateTextField:", forControlEvents: UIControlEvents.ValueChanged)
        birthdayTextField.inputView = picker;
        
//        var toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.bounds.width, 44));
//        toolbar.barStyle = UIBarStyle.Default;
//        var barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
//        var next = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "endEditing")
//        toolbar.items = [barButtonItem, next];
//        birthdayTextField.inputAccessoryView = toolbar;
    
    
        // Do any additional setup after loading the view.
    }
    
    func endEditing() {
        self.view.endEditing(true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateTextField(sender: AnyObject) {
        let picker = birthdayTextField.inputView as! UIDatePicker
        picker.maximumDate = NSDate();
        let dateFormat = NSDateFormatter()
        let eventDate = picker.date;
        dateFormat.dateFormat = "MMMM dd, yyyy";
        let dateString = dateFormat.stringFromDate(eventDate)
        birthdayTextField.text = dateString;
    }
    
    @IBAction func transitionToSignInViewController() {
        let dest = UIUtil.getViewControllerFromStoryboard("SignInVC") as!UIViewController;
        UIView.beginAnimations("LeftFlip", context: nil);
        UIView.setAnimationDuration(0.5);
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut);
        UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: self.view.superview!, cache: true);
        UIView.commitAnimations();
        
        self.view.window?.rootViewController = dest;
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event);
        self.view.endEditing(true);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
