//
//  VTAFilteredSearchViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 2/29/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAFilteredSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VTAPollTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var polls = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.registerNib(UINib(nibName: "VTAPollTableViewCell", bundle: nil), forCellReuseIdentifier: "VTAPollTableViewCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        navigationController?.navigationBar.hidden = false
        
        VTAPostClient.pollsWithIssue(self.title!, success: { (polls) -> Void in
            self.polls = polls
            self.tableView.reloadData()
        }) { (error) -> Void in
            print("VTAFilteredSearchViewController-viewWillAppear-pollsWithIssue: \(error)")
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
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
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let poll = polls[indexPath.row] as PFObject
        
        let pollCell = tableView.dequeueReusableCellWithIdentifier("VTAPollTableViewCell", forIndexPath: indexPath) as! VTAPollTableViewCell
        pollCell.configureWithPollObject(poll)
        pollCell.delegate = self
        return pollCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let poll = polls[indexPath.row] as PFObject
        
        if let _ = poll["image"] as? PFFile {
            return 294
        }
        return 170.0
    }

}
