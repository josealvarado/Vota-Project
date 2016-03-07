//
//  VTAProfileViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 2/11/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VTAPollTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var polls = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.registerNib(UINib(nibName: "VTAProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "VTAProfileTableViewCell")
        tableView.registerNib(UINib(nibName: "VTAPollTableViewCell", bundle: nil), forCellReuseIdentifier: "VTAPollTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        guard let currentUser = PFUser.currentUser() else { return }
        
        VTAPollClient.pollsByUser(currentUser, success: { (polls) -> Void in
            self.polls = polls
            self.tableView.reloadData()
            }) { (error) -> Void in
                print("VTAProfileViewController, viewWillAppear, pollsByUser: \(error)")
        }
    }
    
    // MARK: - User Interactions
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polls.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let profileCell = tableView.dequeueReusableCellWithIdentifier("VTAProfileTableViewCell", forIndexPath: indexPath) as! VTAProfileTableViewCell
            profileCell.configureCellWithProfile(PFUser.currentUser())
            //        pollCell.delegate = self
            return profileCell
        }
        
        let poll = polls[indexPath.row - 1] as PFObject
        
        let pollCell = tableView.dequeueReusableCellWithIdentifier("VTAPollTableViewCell", forIndexPath: indexPath) as! VTAPollTableViewCell
        pollCell.configureWithPollObject(poll)
        pollCell.delegate = self
        return pollCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        }
        
        let poll = polls[indexPath.row - 1] as PFObject
        
        if let _ = poll["image"] as? PFFile {
            return 294
        }
        return 170.0
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VTAPollDetailViewController" {
            let controller = segue.destinationViewController as! VTAPollDetailViewController
            controller.hidesBottomBarWhenPushed = true
            controller.navigationItem.hidesBackButton = true
            controller.poll = sender as! PFObject
        }
    }
    
    // MARK: - VTAPollTableViewCellDelegate
    func pollSelected(dict: [String: AnyObject]) {
        if let type = dict["type"] as? String where type == "detail", let poll = dict["poll"] as? PFObject {
            performSegueWithIdentifier("VTAPollDetailViewController", sender: poll)
        }
    }
}
