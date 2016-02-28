//
//  VTAHomeViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 2/15/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VTAPollTableViewCellDelegate {

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
        VTAPostClient.polls(
            { (polls) -> Void in
                self.polls = polls
                self.tableView.reloadData()
            }, failure: { (error) -> Void in
                print("ERROR, HomeViewController, \(error)")
        })
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
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VTANewPollViewController" {
            let bottomBar = segue.destinationViewController as! VTANewPollViewController
            bottomBar.hidesBottomBarWhenPushed = true
            bottomBar.navigationItem.hidesBackButton = true
        } else if segue.identifier == "VTAPollDetailViewController" {
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
