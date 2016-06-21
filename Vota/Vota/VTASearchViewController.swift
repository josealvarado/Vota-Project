//
//  VTASearchViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 2/29/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTASearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var politicsButton: UIButton!
    @IBOutlet weak var peopleButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedOption = 0
    
    var issues = [PFObject]()
    var users = [PFObject]()
    var selectedList = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.registerNib(UINib(nibName: "VTAUserTableViewCell", bundle: nil), forCellReuseIdentifier: "VTAUserTableViewCell")
        
        VTAIssueClient.issuesObjects({ (issues) -> Void in
            self.issues = issues
            self.selectedList = issues
            self.tableView.reloadData()
            }, failure: { (error) -> Void in
                print("VTASearchViewController, issueButtonPressed, getting issues : \(error)")
        })
        
        VTAUserClient.userObjects({ (users) -> Void in
            self.users = users
            }, failure: { (error) -> Void in
                print("VTASearchViewController, peopleButtonPressed, getting users : \(error)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        navigationController?.navigationBar.hidden = true
        
        if selectedOption == 0 {
            self.selectedList = issues
        } else {
            self.selectedList = users
        }
        self.tableView.reloadData()
    }
    
    // MARK: - User Interactions
    
    
    
    @IBAction func homeTabrBarButtonPressed(sender: UIButton) {
        VTAVotaSettings.sharedInstance.targetView = .Home
        self.dismissViewControllerAnimated(false) {
        }
    }
    
    @IBAction func searchTabBarButtonPressed(sender: UIButton) {
        VTAVotaSettings.sharedInstance.targetView = .Search
        self.dismissViewControllerAnimated(false) {
        }
    }
    @IBAction func infoTabBarButtonPressed(sender: UIButton) {
        VTAVotaSettings.sharedInstance.targetView = .Info
        self.dismissViewControllerAnimated(false) {
        }
    }
    @IBAction func profileTabBarButtonPressed(sender: UIButton) {
        VTAVotaSettings.sharedInstance.targetView = .Profile
        self.dismissViewControllerAnimated(false) {
        }
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
    
    @IBAction func issueButtonPressed(sender: AnyObject) {
        if selectedOption != 0 {
            selectedOption = 0

            politicsButton.setTitleColor(VTAStyleClass.darkBlueColor(), forState: .Normal)
            peopleButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            
            self.selectedList = issues
            self.tableView.reloadData()
            
            VTAIssueClient.issuesObjects({ (issues) -> Void in
                self.issues = issues
                self.selectedList = issues
                self.tableView.reloadData()
                }, failure: { (error) -> Void in
                    print("VTASearchViewController, issueButtonPressed, getting issues : \(error)")
            })
        }
    }
    
   

    @IBAction func peopleButtonPressed(sender: AnyObject) {
        if selectedOption != 1 {
            selectedOption = 1

            politicsButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            peopleButton.setTitleColor(VTAStyleClass.darkBlueColor(), forState: .Normal)
            
            self.selectedList = users
            self.tableView.reloadData()

            VTAUserClient.userObjects({ (users) -> Void in
                self.users = users
                print("users found \(users.count)")
                self.selectedList = users
                self.tableView.reloadData()
            }, failure: { (error) -> Void in
                print("VTASearchViewController, peopleButtonPressed, getting users : \(error)")
            })
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VTAFilteredSearchViewController" {
            var issue = ""
            if let text = selectedList[sender as! Int]["name"] as? String where text != "" {
                issue = text
            }
            let controller = segue.destinationViewController as! VTAFilteredSearchViewController
            controller.title = issue
            controller.hidesBottomBarWhenPushed = true
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        

        if selectedOption == 1 {
            let user = selectedList[indexPath.row] as PFObject
            
            let userCell = tableView.dequeueReusableCellWithIdentifier("VTAUserTableViewCell", forIndexPath: indexPath) as! VTAUserTableViewCell
            userCell.configureCellWithUser(user as! PFUser)
            return userCell
        }
        
        var issue = ""
        if let text = selectedList[indexPath.row]["name"] as? String where text != "" {
            issue = text
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier( "IssueCell", forIndexPath: indexPath)
        let label = cell.viewWithTag(100) as! UILabel
        label.text = issue.capatilizeEveryFirstCharacterOfEveryWord()

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectedOption == 1 {
            return 70
        }
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedOption == 0 {
            performSegueWithIdentifier("VTAFilteredSearchViewController", sender: indexPath.row)
        } else {
            guard let user = selectedList[indexPath.row] as? PFUser else { return }            
            guard let profileVC = self.storyboard!.instantiateViewControllerWithIdentifier("VTAProfileViewController") as? VTAProfileViewController else { return }
            
            profileVC.hidesBottomBarWhenPushed = true
            profileVC.viewingOtherUser = true
            profileVC.otherUser = user
            self.presentViewController(profileVC, animated: false, completion: {
                
            })
        }
    }

}
