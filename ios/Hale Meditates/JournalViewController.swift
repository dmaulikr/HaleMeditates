//
//  JournalViewController.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 7/11/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var addJournalLabel: UILabel!
    
    @IBOutlet weak var finishedButton: UIButton!
    
    @IBOutlet weak var calendarDateLabel: UILabel!
    
    @IBOutlet weak var meditationDurationTimesLabel: UILabel!
    
    @IBOutlet weak var meditationDurationLabel: UILabel!
    
    var model: JournalEntry?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.contentInset.top = -16;
        textView.delegate = self;
        
        if (model != nil) {
            calendarDateLabel.text = model!.startDateString;
            meditationDurationTimesLabel.text = "\(model!.getStartTime) - \(model!.getEndTime)"
            meditationDurationLabel.text = model!.totalTime;
            textView.text = model?.entry
            if (model!.entry != nil && (model!.entry!).characters.count > 0) {
                self.addJournalLabel.text = "Tap to Edit Entry";
            } else {
                self.addJournalLabel.hidden = true;
            }
        }
        
        self.textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5);
    }
    
    var firstShow = true;
    override func viewWillAppear(animated: Bool) {
        if (firstShow && self.addJournalLabel.text == "Tap to Edit Entry") {
            UIView.animateWithDuration(1.5, delay: 1.0, options: [], animations: ({
                self.addJournalLabel.alpha = 0.0;
            }), completion: nil);
        } else if (firstShow && self.addJournalLabel.text == "Add Journal") {
            self.textView.becomeFirstResponder()
        }
        firstShow = false;
        
        super.viewWillAppear(animated);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.addJournalLabel.hidden = true;
        self.finishedButton.hidden = false;
        self.textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0);
        return true;
    }

    @IBAction func handleFinishButtonPressed() {
        self.textView.resignFirstResponder()
        self.finishedButton.hidden = true;
        if (self.textView.text == "") {
            self.addJournalLabel.hidden = false;
        }
        self.textView.textColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5);
    }

    @IBAction func exitView() {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    @IBAction func saveJournalAndExit() {
        model?.entry = textView.text;
        if model?.id != nil {
            API.editJournalEntry(self.model!, callback: {(success: Bool) in
                self.exitView();
            });
        } else {
            API.addJournalEntry(self.model!, callback: {(success: Bool) in
                self.exitView();
            });
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
