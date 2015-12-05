//
//  JournalsContainerViewController.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 7/11/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit

class JournalsContainerViewController: UIViewController {

    @IBOutlet weak var journalsTableViewContainer: UIView!
    var journalsTableViewController: JournalsTableViewController?
    var model: Array<JournalEntry>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (DataContext.journalEntries != nil) {
            self.model = DataContext.journalEntries;
            addJournalsTableViewController();
        } else {
            DataContext.getJournalEntries(({ (journalEntries: Array<JournalEntry>?) in
                self.model = journalEntries;
                dispatch_async(dispatch_get_main_queue(), ({
                    self.addJournalsTableViewController();
                }));
            }));
        }

        // Do any additional setup after loading the view.
    }
    
    func addJournalsTableViewController() {
        self.journalsTableViewController = UIUtil.getViewControllerFromStoryboard("JournalsTableViewController") as? JournalsTableViewController;
        self.journalsTableViewController?.model = self.model;
        self.addChildViewController(self.journalsTableViewController!);
        self.journalsTableViewController?.view.frame = self.journalsTableViewContainer.bounds;
        self.journalsTableViewContainer.addSubview(self.journalsTableViewController!.view);
        self.journalsTableViewController?.didMoveToParentViewController(self);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
