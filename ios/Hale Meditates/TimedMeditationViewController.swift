//
//  TimedMeditationViewController.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 6/28/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit

class TimedMeditationViewController: UIViewController, UIAlertViewDelegate, AudioPlaybackDelegate {
    
    var model: MeditationSettings?

    @IBOutlet weak var audioPlaybackContainer: UIView!
    @IBOutlet weak var timerViewContainer: UIView!
    @IBOutlet weak var meditationLabel: UILabel!
    @IBOutlet weak var timerView: TimerView!
    
    var journalEntry = JournalEntry();
    var audioSession: AudioSession?
    var audioPlaybackController: AudioPlaybackViewController?
    
    var countup: Int? = 20 {
        didSet {
            if (countup != nil) {
                updateMeditationText(countup!, label: "Relaxation");
                if (countup == 0) {
                    endMeditation();
                }
            }
        }
    };

    var countdown: Int? = 10 {
        didSet {
            if (countdown != nil) {
                updateMeditationText(countdown!, label: "Preparation");
                if (countdown == 0) {
                    startMeditation();
                }
            }
        }
    }
    
    var initialMeditationTime = 20 // 10 minutes
    var meditationTimeRemaining = 20 {
        didSet {
            self.timerView?.progress = Float(initialMeditationTime - meditationTimeRemaining) / Float(initialMeditationTime);
            if (meditationTimeRemaining == 0) {
                self.startRelaxationPeriod();
            }
        }
    }
    
    var timerInterval:Double = 1.0;
    var timer: NSTimer?;
    
    func formatText(time: Int, label: String) -> String {
        if (time > 60) {
            let minutes = time / 60;
            let seconds = time % 60;
            return "\(minutes)m\(seconds)s\n\(label)"
            
        } else {
            return "\(time)s\n\(label)";
        }
    }
    
    var meditationEnded = false;
    
    func endMeditation() {
        if (meditationEnded) {
            return;
        }
        meditationEnded = true;
        journalEntry.endDate = NSDate();
        timer?.invalidate();
        self.meditationLabel.text = "Finished";
        let message: String? = "You've finished your meditation. Would you like to add a journal entry?"
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction) in
            let journalViewController = UIUtil.getViewControllerFromStoryboard("JournalViewController") as? JournalViewController;
            journalViewController?.model = self.journalEntry;
        self.navigationController?.setViewControllers([self.navigationController!.viewControllers.first!, journalViewController!], animated: true);
        }));
        alert.addAction(UIAlertAction(title: "No, maybe later", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in self.popToHomeViewController()}));
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func popToHomeViewController() {
        if let topViewController = self.navigationController?.viewControllers.first {
            self.navigationController?.popToViewController(topViewController, animated: true);
        }
    }
    
    @IBAction func finishMeditation() {
        timer?.invalidate();
        if initialMeditationTime == meditationTimeRemaining { // they never started
            popToHomeViewController();
            return;
        }
        self.endMeditation();
        
    }
    
    func startRelaxationPeriod() {
        if audioSession != nil {
            UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: ({
                self.audioPlaybackContainer.alpha = 0.0;
            }), completion: nil);
        }
        timer?.invalidate();
        if (countup != nil) {
            timer = NSTimer.scheduledTimerWithTimeInterval(timerInterval,
                target: self,
                selector: "handleRelaxationTimer:",
                userInfo: nil,
                repeats: true)
            timer?.tolerance = 0.1;
        } else {
            endMeditation();
        }
    }
    
    func startMeditation() {
        journalEntry.startDate = NSDate();
        self.meditationLabel.text = "";
        timer?.invalidate(); // use the same timer since they're mutually exclusive
        
        if audioSession == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(timerInterval,
                target: self,
                selector: "handleMeditationTimer:",
                userInfo: nil,
                repeats: true)
            timer?.tolerance = 0.1;
        } else {
            self.audioPlaybackController?.play();
            UIView.animateWithDuration(0.3, delay: 0.0, options: [], animations: ({
                self.audioPlaybackContainer.alpha = 1.0;
            }), completion: nil);
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        timer?.invalidate();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        if audioSession != nil && audioPlaybackController == nil {
            audioPlaybackController = UIUtil.getViewControllerFromStoryboard("AudioPlaybackViewController") as? AudioPlaybackViewController;
            self.addChildViewController(self.audioPlaybackController!);
            self.audioPlaybackController?.view.frame = self.audioPlaybackContainer.bounds;
            self.audioPlaybackContainer.addSubview(self.audioPlaybackController!.view);
            self.audioPlaybackController?.didMoveToParentViewController(self);
            audioPlaybackController?.model = self.audioSession;
            audioPlaybackController?.delegate = self;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        if (self.model != nil) {
            self.countdown = (self.model!.prep == 0) ? nil : self.model!.prep;
            self.initialMeditationTime = self.model!.meditation;
            self.meditationTimeRemaining = self.model!.meditation;
            self.countup = (self.model!.relax == 0) ? nil : self.model!.relax;
        }
        
        if (countdown != nil) {
            updateMeditationText(countdown!, label: "Preparation");
        } else {
            self.meditationLabel.text = "";
        }
        
        if audioSession == nil {
            audioPlaybackContainer.removeFromSuperview();
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        if (countdown != nil) {
            timer = NSTimer.scheduledTimerWithTimeInterval(timerInterval,
                target: self,
                selector: "handlePreparationTimer:",
                userInfo: nil,
                repeats: true)
            timer?.tolerance = 0.1;
        } else {
            self.startMeditation();
        }
    }
    
    func handleMeditationTimer(timer: NSTimer) {
        handleMeditationTimer();
    }
    
    func handleMeditationTimer() {
        meditationTimeRemaining--;
    }
    
    func handlePreparationTimer(timer: NSTimer) {
        countdown?--;
    }
    
    func handleRelaxationTimer(timer: NSTimer) {
        countup?--;
    }
    
    @IBAction func popViewController() {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func updateMeditationText(time: Int, label: String) {
        self.meditationLabel.text = formatText(time, label: label);
    }
    
    
    func handleTimeChange(current: Float, remaining: Float) {
        let rem = Int(ceil(remaining));
        if rem != meditationTimeRemaining {
            print(rem);
            meditationTimeRemaining = rem;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
