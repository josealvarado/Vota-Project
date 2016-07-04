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
    
    @IBOutlet weak var homeTabBarView: UIView!
    
    @IBOutlet weak var searchTabBarView: UIView!
    
    @IBOutlet weak var learnTabBarView: UIView!
    
    @IBOutlet weak var profileTabBarView: UIView!
    
    var polls = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.registerNib(UINib(nibName: "VTAPollTableViewCell", bundle: nil), forCellReuseIdentifier: "VTAPollTableViewCell")

//        self.hidesBottomBarWhenPushed = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        if VTAVotaSettings.sharedInstance.targetView != .Home {
            openTHisController()
        }

        VTAPollClient.polls(
            { (polls) -> Void in
                self.polls = polls
                self.tableView.reloadData()
            }, failure: { (error) -> Void in
                print("ERROR, HomeViewController, \(error)")
        })
    }
    
    func openTHisController() {
        if VTAVotaSettings.sharedInstance.targetView == .Home {
            
        } else if VTAVotaSettings.sharedInstance.targetView == .Search  {
            let tabViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VTASearchViewController")
            tabViewController.hidesBottomBarWhenPushed = true
            self.presentViewController(tabViewController, animated: false, completion: {
                
            })
        } else if VTAVotaSettings.sharedInstance.targetView == .Info  {
            
        } else if VTAVotaSettings.sharedInstance.targetView == .Profile  {
            let tabViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VTAProfileViewController")
            tabViewController.hidesBottomBarWhenPushed = true
            self.presentViewController(tabViewController, animated: false, completion: {
                
            })
        }
    }
    
    // MARK: - User Interactions
    
    @IBAction func searchTabBarButtonPRessed(sender: UIButton) {
        let tabViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VTASearchViewController")
        tabViewController.hidesBottomBarWhenPushed = true
        self.presentViewController(tabViewController, animated: false, completion: {
            
        })
    }
    
    
    @IBAction func learnTabBarButtonPressed(sender: UIButton) {
    }
    
    @IBAction func profileTabBarButtonPressed(sender: UIButton) {
        let tabViewController = self.storyboard!.instantiateViewControllerWithIdentifier("VTAProfileViewController")
        tabViewController.hidesBottomBarWhenPushed = true
        self.presentViewController(tabViewController, animated: false, completion: {
          
        })
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Featured News"
//        }
//        return "Polls"
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 0
//        }
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
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 240.0
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
