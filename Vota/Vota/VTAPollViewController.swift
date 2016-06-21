//
//  VTAPollViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 6/14/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit


public enum PollViewType: Int {
    case PollsMade = 0, PollsVoted, Followers, Following
}


class VTAPollViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var polls = [PFObject]()
    var pollViewType = PollViewType.PollsMade
    
    var viewingOtherUser = false
    var otherUser: PFUser?

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
        var currentUser:PFUser!
        
        if viewingOtherUser {
            currentUser = otherUser
        } else {
            currentUser = PFUser.currentUser()
        }
        
        
        switch pollViewType {
        case .PollsMade:
            print("polls made")
            
            VTAPollClient.pollsByUser(currentUser, success: { (polls) in
                self.polls = polls
                self.tableView.reloadData()
                }, failure: { (error) in
                    
            })
        case .PollsVoted:
            print("polls voted")
            
//            VTAPollClient.pollsVotedByUser(currentUser, success: { (polls) in
//                self.polls = polls
//                self.tableView.reloadData()
//                }, failure: { (error) in
//                    
//            })
        case .Followers:
            print("followers")
        case .Following:
            print("following")
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
//        pollCell.delegate = self
        return pollCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //        if indexPath.section == 0 {
        //            return 150
        //        }
        
        return 228.0
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
