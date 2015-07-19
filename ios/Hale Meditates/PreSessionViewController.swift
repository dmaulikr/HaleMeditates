//
//  PreSessionViewContro.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 7/10/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit

class PreSessionViewController: UIViewController {
    
    var model: MeditationSettings?
    
    @IBOutlet weak var meditationLabel: UILabel!
    @IBOutlet weak var prepLabel: UILabel!
    @IBOutlet weak var relaxationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = MeditationSettings();
        model?.meditation = 60 * 5;
        model?.prep = 20;
        model?.relax = 30;
        // Do any additional setup after loading the view.
        setUI();
    }
    
    func setUI() {
        self.prepLabel.text = UIUtil.formatTimeString(self.model!.prep);
        self.meditationLabel.text = UIUtil.formatTimeString(self.model!.meditation);
        self.relaxationLabel.text = UIUtil.formatTimeString(self.model!.relax);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.destinationViewController is MeditationSettingsViewController) {
            (segue.destinationViewController as! MeditationSettingsViewController).model = self.model;
        }
        
        if (segue.destinationViewController is TimedMeditationViewController) {
            (segue.destinationViewController as! TimedMeditationViewController).model = self.model;
        }
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
