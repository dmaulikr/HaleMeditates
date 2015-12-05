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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        DataContext.getJournalEntries(({ (journalEntries: Array<JournalEntry>?) in
            self.model = journalEntries;
            dispatch_async(dispatch_get_main_queue(), ({
                
                if self.journalsTableViewController == nil {
                    self.addJournalsTableViewController();
                } else {
                    self.journalsTableViewController?.model = self.model;
                }
                
            }));
        }));
    }
    
    func addJournalsTableViewController() {
        self.journalsTableViewController = UIUtil.getViewControllerFromStoryboard("JournalsTableViewController") as? JournalsTableViewController;
        self.addChildViewController(self.journalsTableViewController!);
        self.journalsTableViewController?.model = self.model;
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
