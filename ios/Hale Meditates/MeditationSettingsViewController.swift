//
//  MeditationSettingsViewController.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 7/10/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit

class MeditationSettingsViewController: UIViewController {
    
    var disableEditingForMeditationTime: Bool = false;
    
    var model: MeditationSettings? {
        didSet {
            cloneModel = MeditationSettings.clone(model!);
        }
    }
    
    var cloneModel: MeditationSettings?

    @IBOutlet weak var relaxationContainer: UIView!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var meditationTimeLabel: UILabel!
    @IBOutlet weak var relaxTimeLabel: UILabel!
    
    @IBOutlet weak var prepSlider: UISlider!
    @IBOutlet weak var meditationSlider: UISlider!
    @IBOutlet weak var relaxSlider: UISlider!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepSlider.minimumValue = Float(MeditationSettings.MIN_PREP);
        meditationSlider.minimumValue = Float(MeditationSettings.MIN_MEDITATION);
        relaxSlider.minimumValue = Float(MeditationSettings.MIN_RELAX);
        prepSlider.maximumValue = Float(MeditationSettings.MAX_PREP);
        meditationSlider.maximumValue = Float(MeditationSettings.MAX_MEDITATION);
        relaxSlider.maximumValue = Float(MeditationSettings.MAX_RELAX);
        if disableEditingForMeditationTime {
            self.relaxationContainer.removeFromSuperview();
        }
        setUI();
    }
    
    @IBOutlet weak var save: UIButton!
    
    @IBAction func close() {
        _ = self.presentingViewController;
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
    }

    
    @IBAction func saveMeditationSettings() {
        self.model?.meditation = self.cloneModel!.meditation;
        self.model?.prep = self.cloneModel!.prep;
        self.model?.relax = self.cloneModel!.relax;
        
        MeditationSettings.saveUsersMeditationSettings(self.model!);

        let presenter = self.presentingViewController;
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: ({
            if (presenter is PreSessionViewController) {
                (presenter as? PreSessionViewController)?.setUI();
            }
        }));
    }
    
    func setUI() {
        prepSlider.tag = 0;
        relaxSlider.tag = 2;
        
        if !disableEditingForMeditationTime {
            meditationSlider.tag = 1;
        }
        
        if (self.cloneModel != nil) {
            self.prepTimeLabel.text = UIUtil.formatTimeString(self.cloneModel!.prep);
            if !disableEditingForMeditationTime {
                self.meditationTimeLabel.text = UIUtil.formatTimeString(self.cloneModel!.meditation);
            }
            self.relaxTimeLabel.text = UIUtil.formatTimeString(self.cloneModel!.relax);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func settingsSliderChange(sender: UISlider) {
        if (sender.tag == 0) {
            self.cloneModel?.prep = Int(sender.value)
        }
        
        if (sender.tag == 1) {
            self.cloneModel?.meditation = Int(sender.value);
        }
        
        if (sender.tag == 2) {
            self.cloneModel?.relax = Int(sender.value)
        }
        
        setUI();
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
