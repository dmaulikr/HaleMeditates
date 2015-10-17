//
//  SessionsTableViewController.swift
//  Hale Meditates
//
//  Created by Ryan Pillsbury on 6/27/15.
//  Copyright (c) 2015 koait. All rights reserved.
//

import UIKit

class SessionsTableViewController: UITableViewController {
    
    let reuseId = "sessionTableViewCell";
    var model: Array<AudioSession> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Guided Sessions";
        if (DataContext.audioSessions != nil) {
            self.model = DataContext.audioSessions!;
        } else {
            DataContext.getAudioSessions(({ (audioSessions: Array<AudioSession>?) in
                if audioSessions != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.model = audioSessions!;
                        self.tableView.reloadData();
                    });
                }
            }))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        let backButton = UIButton(type: UIButtonType.Custom);
        //backButton.frame = CGRectMake(0, 0, 13, 13);
        backButton.sizeToFit();
        backButton.setImage(UIImage(named: "back"), forState: UIControlState.Normal);
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 7);
        backButton.addTarget(self, action: "handleBackButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton);
    }
    
    func handleBackButtonPress() {
        self.navigationController?.popViewControllerAnimated(true);
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.model.count;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableView.frame.height / 6
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: indexPath) as! SessionTableViewCell
        cell.model = self.model[indexPath.row];
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sessionModel = self.model[indexPath.row];
        print(sessionModel.audioUrl!)
        if let preSessionVC = UIUtil.getViewControllerFromStoryboard("PreSessionViewController") as? PreSessionViewController {
            preSessionVC.audioSession = sessionModel;
            self.navigationController?.pushViewController(preSessionVC, animated: true);
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
