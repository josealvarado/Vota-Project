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
    var selectedList = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            issueView.backgroundColor = VTAStyleClass.darkBlueColor()
            peopleView.backgroundColor = UIColor.grayColor()
            
            self.selectedList = issues
            self.tableView.reloadData()
            
            selectedOption = 0
        }
    }

    @IBAction func peopleButtonPressed(sender: AnyObject) {
        if selectedOption != 1 {
            issueView.backgroundColor = UIColor.grayColor()
            peopleView.backgroundColor = VTAStyleClass.darkBlueColor()
            
            self.selectedList = []
            self.tableView.reloadData()

            selectedOption = 1
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "VTAFilteredSearchViewController" {
            var issue = ""
            if let text = selectedList[sender as! Int]["name"] as? String where text != "" {
                issue = text
            }
            let controller = segue.destinationViewController as! VTAFilteredSearchViewController
            controller.title = issue
            controller.hidesBottomBarWhenPushed = true
//            controller.navigationItem.hidesBackButton = true
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
        
        print("item \(indexPath.row)")
        
        performSegueWithIdentifier("VTAFilteredSearchViewController", sender: indexPath.row)
    }

}
