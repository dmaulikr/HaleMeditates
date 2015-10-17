//
//  CallToActionViewController.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 6/27/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit

class CallToActionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.title = "Home";

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        super.viewWillAppear(animated);
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
