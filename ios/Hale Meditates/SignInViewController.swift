//
//  ViewController.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 6/8/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self;
        self.passwordTextField.delegate = self;
        setUI()
    }
    
    func setUI() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func transitionToSignUpViewController() {
        let dest = UIUtil.getViewControllerFromStoryboard("SignUpVC") as!UIViewController;
        UIView.beginAnimations("RightFlip", context: nil);
        UIView.setAnimationDuration(0.5);
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut);
        UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: self.view.superview!, cache: true);
        UIView.commitAnimations();
        self.view.window?.rootViewController = dest;
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event);
        self.view.endEditing(true);
    }


}

