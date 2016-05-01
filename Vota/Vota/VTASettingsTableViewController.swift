//
//  VTASettingsTableViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 3/6/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTASettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - User Interactions
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Section \(indexPath.section), Row \(indexPath.row)")
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            
        } else if section == 1 {            
            if row == 0 {
                performSegueWithIdentifier("VTAEmailViewController", sender: nil)
            } else if row == 1 {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://www.votaapp.com/")!)
            } else if row == 2 {
                UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(898611816)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1)")!);
            } else if row == 3 {
                let textToShare = "Download Vota!"
                
                if let myWebsite = NSURL(string: "http://www.votaapp.com/")
                {
                    let objectsToShare = [textToShare, myWebsite]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    
                    //New Excluded Activities Code
                    activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList, UIActivityTypeCopyToPasteboard]
                    
                    self.presentViewController(activityVC, animated: true, completion: nil)
                }
            } else if row == 4 {
                PFUser.logOut()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    

}
