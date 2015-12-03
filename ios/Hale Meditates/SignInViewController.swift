//
//  ViewController.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 6/8/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var errorMessage: String? {
        didSet {
            setErrorMessageLabelState();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self;
        self.passwordTextField.delegate = self;
        setUI()
    }
    
    
    @IBAction func textFieldChanged(sender: UITextField) {
        setSignInButtonState();
        self.errorMessage = nil;
    }
    
    
    
    @IBAction func attemptToSignIn() {
        setSignInButtonState(false);
        Alamofire.request(.POST, Globals.API_ROOT + "/auth/signin", parameters:
            [
                "username": self.emailTextField.text ?? "",
                "password": self.passwordTextField.text ?? ""
            ])
            .responseJSON { response in
                if response.response?.statusCode == 200 {
                    self.transitionToTabBarController();
                } else {
                    print(response.result.value!);
                    if let errorMsg = (response.result.value as? NSDictionary)?["message"] as? String {
                        self.errorMessage = errorMsg;
                        self.setSignInButtonState(true);
                    }
                }
        }
    }
    
    func transitionToTabBarController() {
        let dest = UIUtil.getViewControllerFromStoryboard("MainTabBarController") as! UITabBarController;
        let w = self.view.window;
        UIView.transitionFromView(self.view, toView: dest.view, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, completion: {
            (value: Bool) in
            w?.rootViewController = dest;
        });
    }
    
    func setUI() {
        setErrorMessageLabelState();
        setSignInButtonState();
    }
    
    func setErrorMessageLabelState() {
        self.errorMessageLabel.hidden = errorMessage == nil;
        self.errorMessageLabel.text = errorMessage;
    }
    
    func setSignInButtonState (force: Bool? = nil) {
        if let forcedState = force {
            self.signInButton.enabled = forcedState;
            self.signInButton.alpha = (forcedState) ? 1.0 : 0.5;
            return;
        }
        
        
        if self.emailTextField.text == nil || self.passwordTextField.text == nil {
            self.signInButton.enabled = false;
            self.signInButton.alpha = 0.5;
            return;
        }
        
        if !(self.emailTextField.text!.characters.count > 0) || !(self.passwordTextField.text!.characters.count > 0) {
            self.signInButton.enabled = false;
            self.signInButton.alpha = 0.5;
            return;
        }
    
        self.signInButton.enabled = true;
        self.signInButton.alpha = 1.0;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func transitionToViewController(dest: UIViewController, transition: UIViewAnimationTransition = UIViewAnimationTransition.FlipFromRight) {
        UIView.beginAnimations("RightFlip", context: nil);
        UIView.setAnimationDuration(0.5);
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut);
        UIView.setAnimationTransition(transition, forView: self.view.superview!, cache: true);
        UIView.commitAnimations();
        self.view.window?.rootViewController = dest;
    }
    
    @IBAction func transitionToSignUpViewController() {
        transitionToViewController(UIUtil.getViewControllerFromStoryboard("SignUpVC") as! UIViewController);
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event);
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return false;
    }



}

