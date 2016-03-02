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
    @IBOutlet weak var issueView: UIView!
    @IBOutlet weak var peopleView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedOption = 0
    
    var issues = [PFObject]()
    var users = [PFObject]()
    var selectedList = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.registerNib(UINib(nibName: "VTAUserTableViewCell", bundle: nil), forCellReuseIdentifier: "VTAUserTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true);
        navigationController?.navigationBar.hidden = true
        
        VTAIssueClient.issuesObjects({ (issues) -> Void in
            self.issues = issues
            self.selectedList = issues
            self.tableView.reloadData()
            }, failure: { (error) -> Void in
                print("VTASearchViewController, issueButtonPressed, getting issues : \(error)")
        })
    }
    
    // MARK: - User Interactions
    @IBAction func issueButtonPressed(sender: AnyObject) {
        if selectedOption != 0 {
            selectedOption = 0

            issueView.backgroundColor = VTAStyleClass.darkBlueColor()
            peopleView.backgroundColor = UIColor.grayColor()
            
            self.selectedList = issues
            self.tableView.reloadData()
        }
    }

    @IBAction func peopleButtonPressed(sender: AnyObject) {
        if selectedOption != 1 {
            selectedOption = 1

            issueView.backgroundColor = UIColor.grayColor()
            peopleView.backgroundColor = VTAStyleClass.darkBlueColor()
            
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
        label.text = issue

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectedOption == 1 {
            return 70
        }
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("VTAFilteredSearchViewController", sender: indexPath.row)
    }

}
