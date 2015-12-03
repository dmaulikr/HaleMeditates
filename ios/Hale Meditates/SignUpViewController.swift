//
//  SignUpViewController.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 6/10/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var birthdayTextField: UITextField!
    
    var errorMessage: String? {
        didSet {
            setErrorMessageLabelState();
        }
    }
    
    var firstName: String? {
        get {
            if let fullName = fullNameTextField?.text {
                let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
                return fullNameArr.first;
            } else {
                return nil
            }
        }
    }
    
    var lastName: String? {
        get {
            if let fullName = fullNameTextField?.text {
                let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
                return (fullNameArr.count > 1) ? fullNameArr.last : nil
            } else {
                return nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let picker =  UIDatePicker();
        picker.date = NSDate(timeIntervalSinceNow: NSTimeInterval(-13 * 365 * 24 * 60 * 60));
        picker.datePickerMode = UIDatePickerMode.Date;
        picker.addTarget(self, action: "dateTextField:", forControlEvents: UIControlEvents.ValueChanged)
        birthdayTextField.inputView = picker;
        
        self.fullNameTextField.delegate = self;
        self.emailTextField.delegate = self;
        self.passwordTextField.delegate = self;
    }
    
    func setUI() {
        setErrorMessageLabelState();
        setSignUpButtonState();
    }
    
    func endEditing() {
        self.view.endEditing(true);
    }
    
    func setErrorMessageLabelState() {
        self.errorMessageLabel.hidden = errorMessage == nil;
        self.errorMessageLabel.text = errorMessage;
    }

    @IBAction func textFieldChanged(sender: UITextField) {
        setSignUpButtonState();
        self.errorMessage = nil;
    }
    
    func setSignUpButtonState(force: Bool? = nil) {
        if let forcedState = force {
            self.signUpButton.enabled = forcedState;
            self.signUpButton.alpha = (forcedState) ? 1.0 : 0.5;
            return;
        }
        
        if self.emailTextField.text == nil || self.passwordTextField.text == nil || self.fullNameTextField == nil || self.birthdayTextField == nil {
            self.signUpButton.enabled = false;
            self.signUpButton.alpha = 0.5;
            return;
        }
        
        if !(self.emailTextField.text!.characters.count > 0) || !(self.passwordTextField.text!.characters.count > 0) || !(self.fullNameTextField.text!.characters.count > 0) || !(self.birthdayTextField.text!.characters.count > 0) {
            self.signUpButton.enabled = false;
            self.signUpButton.alpha = 0.5;
            return;
        }
        
        self.signUpButton.enabled = true;
        self.signUpButton.alpha = 1.0;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return false;
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
    
    @IBAction func attemptSignUp() {
        setSignUpButtonState(false);
        let params: [String : AnyObject] = [
            "firstName": self.firstName ?? "",
            "lastName": self.lastName ?? "",
            "username": self.emailTextField.text ?? "",
            "email": self.emailTextField.text ?? "",
            "password": self.passwordTextField.text ?? "",
            "roles": ["user"],
            "birthDate": self.birthdayTextField.text ?? ""
        ]
        Alamofire.request(.POST, Globals.API_ROOT + "/auth/signup", parameters: params)
            .responseJSON { response in
                if response.response?.statusCode == 200 {
                    let dest = UIUtil.getViewControllerFromStoryboard("JoyrideViewController") as! UIViewController;
                    self.transitionToViewController(dest, transition: UIViewAnimationTransition.FlipFromLeft);
                } else {
                    print(response.result.value!);
                    if let errorMsg = (response.result.value as? NSDictionary)?["message"] as? String {
                        self.errorMessage = errorMsg;
                        self.setSignUpButtonState(true);
                    }
                }
        }
    }
    
    func transitionToViewController(dest: UIViewController, transition: UIViewAnimationTransition = UIViewAnimationTransition.FlipFromRight) {
        UIView.beginAnimations("LeftFlip", context: nil);
        UIView.setAnimationDuration(0.5);
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut);
        UIView.setAnimationTransition(transition, forView: self.view.superview!, cache: true);
        UIView.commitAnimations();
        self.view.window?.rootViewController = dest;
    }
    
    @IBAction func transitionToSignInViewController() {
        let dest = UIUtil.getViewControllerFromStoryboard("SignInVC") as!UIViewController;
        transitionToViewController(dest, transition: UIViewAnimationTransition.FlipFromLeft);
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
