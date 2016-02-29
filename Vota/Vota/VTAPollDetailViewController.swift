//
//  VTAPollDetailViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 2/28/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAPollDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var poll: PFObject!
    var comments = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.registerNib(UINib(nibName: "VTAPollTableViewCell", bundle: nil), forCellReuseIdentifier: "VTAPollTableViewCell")
        tableView.registerNib(UINib(nibName: "VTACommentTableViewCell", bundle: nil), forCellReuseIdentifier: "VTACommentTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Interactions
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func shareButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        guard let text = textField.text where text != "" else { return }
        
        let post = PFObject(className: "Comment")
        post["user"] = PFUser.currentUser()
        post["poll"] = poll
        post["text"] = text
        post.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
            self.textField.text = ""

            if success {
                self.tableView.reloadData()
            } else if let error = error {
                print("ERROR, VTAPollDetailViewController: \(error)")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        VTACommentClient.commentObjectsForPoll(poll, success: { (comments) -> Void in
            print("number of comments \(comments.count)")
            self.comments = comments
            self.tableView.reloadData()
        }) { (error) -> Void in
            print("ERROR, VTAPollDetailViewController, \(error)")
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let pollCell = tableView.dequeueReusableCellWithIdentifier("VTAPollTableViewCell", forIndexPath: indexPath) as! VTAPollTableViewCell
            pollCell.configureWithPollObject(poll)
            return pollCell
        }
        
        let comment = comments[indexPath.row - 1]
        let comentCell = tableView.dequeueReusableCellWithIdentifier("VTACommentTableViewCell", forIndexPath: indexPath) as! VTACommentTableViewCell
        comentCell.configureCellWithCommentObject(comment)
        return comentCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if let _ = poll["image"] as? PFFile {
                return 294
            }
            return 170.0
        }
        
        let comment = self.comments[indexPath.row - 1]
        let text = comment["text"] as! String!
        let h = heightForView(text, font: UIFont.systemFontOfSize(14.0), width: 250.0)
        return 90.0 + h - 50.0;
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UITextView = UITextView(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }

}
