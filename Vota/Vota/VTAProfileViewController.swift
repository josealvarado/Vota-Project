//
//  VTAProfileViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 2/11/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAProfileViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UITextView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var follwersButton: UIButton!
    @IBOutlet weak var pollsMadeButton: UIButton!
    @IBOutlet weak var pollsVotedButton: UIButton!
    
    var polls = [PFObject]()
    var viewingOtherUser = false
    var otherUser: PFUser?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        guard let currentUser = PFUser.currentUser() else {
            self.dismissViewControllerAnimated(false, completion: nil)
            return
        }
        
        if let otherUser = otherUser where otherUser.email != currentUser.email {
            setupUser(otherUser)
            bottomContainerView.hidden = true
            backButton.hidden = false
        } else {
            bottomContainerView.hidden = false
            backButton.hidden = true
            
            setupUser(currentUser)
        }
    }
    
    func setupUser(user : PFUser) {
        usernameLabel.text = user.username ?? ""
        bioLabel.text = user["bio"] as? String ?? ""
        
        VTAUserClient.numberOfFollowingForUser(user, success: { (count) in
            self.followingButton.setTitle("\(count) Following", forState: .Normal)
        }) { (error) in
            self.followingButton.setTitle("0 Following", forState: .Normal)
        }
        
        VTAUserClient.numberOfFollowersForUser(user, success: { (count) in
            self.follwersButton.setTitle("\(count) Followers", forState: .Normal)
        }) { (error) in
            self.follwersButton.setTitle("0 Followers", forState: .Normal)
        }
        
        VTAPollController.numberOfPollsByUser(user) { (count) in
            self.pollsMadeButton.setTitle("\(count) Polls Made", forState: .Normal)
        }
        
        VTAPollController.numberOfPollsVotedOnByUser(user) { (count) in
            self.pollsVotedButton.setTitle("\(count) Polls Voted", forState: .Normal)
        }
    }
    
    // MARK: - User Interactions
    
    @IBAction func backButtonPressed(sender: UIButton) {
        if sender.hidden == true {
            return
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func homeTabrBarButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(false) { 
            
        }
    }
    
    @IBAction func pollsMadeButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("pollsViewController", sender: nil)
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
    
//    // MARK: - VTAPollTableViewCellDelegate
//    func pollSelected(dict: [String: AnyObject]) {
//        if let type = dict["type"] as? String where type == "detail", let poll = dict["poll"] as? PFObject {
//            performSegueWithIdentifier("VTAPollDetailViewController", sender: poll)
//        }
//    }
}
