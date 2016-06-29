//
//  VTAProfileViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 2/11/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var registeredToVoteLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var bioLabel: UITextView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var follwersButton: UIButton!
    @IBOutlet weak var pollsMadeButton: UIButton!
    @IBOutlet weak var pollsVotedButton: UIButton!
    
    var polls = [PFObject]()
    var viewingOtherUser = false
    var otherUser: PFUser?
    
    var profileImage: UIImage?

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
            editProfileButton.hidden = true
        } else {
            bottomContainerView.hidden = false
            backButton.hidden = true
            editProfileButton.hidden = false
            setupUser(currentUser)
        }
    }
    
    func setupUser(user : PFUser) {
        usernameLabel.text = user["name"] as? String ?? ""
        bioLabel.text = user["bio"] as? String ?? ""
        
        if let image = user["image"] as? PFFile {
            image.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if let imageData = imageData, image = UIImage(data: imageData) {
                    self.profileImageView.image = image
                }
            })
        }
        
        if let registeredToVote = user["registeredToVote"] as? Bool where registeredToVote == true {
            registeredToVoteLabel.text = "Registered to vote"
        } else {
            registeredToVoteLabel.text = "Not yet registered to vote"
        }
        
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
        
        VTAUserClient.numberOfPollsForUser(user, success: { (count) in
            self.pollsMadeButton.setTitle("\(count) Polls Made", forState: .Normal)
            }) { (error) in
                self.pollsMadeButton.setTitle("0 Polls Made", forState: .Normal)
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
    
    @IBAction func profileImageButtonPressed(sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.allowsEditing = false
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func profileRegisteredToVoteButtonPressed(sender: UIButton) {
        guard let currentUser = PFUser.currentUser() else {
            self.dismissViewControllerAnimated(false, completion: nil)
            return
        }
        
        if let otherUser = otherUser where otherUser.email != currentUser.email {

        } else {
            if let registeredToVote = currentUser["registeredToVote"] as? Bool where registeredToVote == true {
                registeredToVoteLabel.text = "Not yet registered to vote"
                currentUser["registeredToVote"] = false
            } else {
                registeredToVoteLabel.text = "Registered to vote"
                currentUser["registeredToVote"] = true
            }
            currentUser.saveInBackgroundWithBlock({ (savedSuccessfully, error) in
            })
        }
    }
    
    @IBAction func registeredToVoteButtonPressed(sender: UIButton) {
        guard let currentUser = PFUser.currentUser() else {
            self.dismissViewControllerAnimated(false, completion: nil)
            return
        }
        
        if let otherUser = otherUser where otherUser.email != currentUser.email {
            setupUser(otherUser)
        } else {
            if let registeredToVote = currentUser["registeredToVote"] as? Bool where registeredToVote == false {
                currentUser["registeredToVote"] = true
                currentUser.saveInBackgroundWithBlock({ (isSuccessful, error) in
                    if isSuccessful {
                        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.usa.gov/register-to-vote")!)
                        self.registeredToVoteLabel.text = "Registered to vote"
                    } else {
                        self.registeredToVoteLabel.text = "Not yet registered to vote"
                    }
                })
            } else {
                currentUser["registeredToVote"] = false
                currentUser.saveInBackgroundWithBlock({ (isSuccessful, error) in
                    self.registeredToVoteLabel.text = "Not yet registered to vote"
                })
            }
        }
    }
    
    @IBAction func editProfileButtonPressed(sender: AnyObject) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("VTALoginViewNavController") as? UINavigationController
        let vcs = controller?.viewControllers
        if vcs?.count > 0 {
            if let loginController = vcs?.first as? VTALoginViewController {
                loginController.editProfile = true
                self.presentViewController(controller!, animated: true, completion: nil)
            }
        }
    }
    
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
    
    @IBAction func pollsMadeButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("pollsViewController", sender: 0)
    }

    @IBAction func pollsVotedButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("pollsViewController", sender: 1)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VTAPollDetailViewController" {
            let controller = segue.destinationViewController as! VTAPollDetailViewController
            controller.hidesBottomBarWhenPushed = true
            controller.navigationItem.hidesBackButton = true
            controller.poll = sender as! PFObject
        } else if segue.identifier == "pollsViewController" {
            
            let controller = segue.destinationViewController as! VTAPollViewController
            
            controller.hidesBottomBarWhenPushed = true
            controller.otherUser = self.otherUser
            
            controller.viewingOtherUser = viewingOtherUser
            controller.otherUser = otherUser
            
            if let pollType = sender as? Int {
                controller.pollViewType = PollViewType(rawValue: pollType)!
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: {
            self.profileImage = image
            self.profileImageView.image = image
            
            guard let currentUser = PFUser.currentUser() else { return }
            let profileImageData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.5)
            let profileImageFile = PFFile(name: "profile.jpeg", data: profileImageData!)
            currentUser["image"] = profileImageFile
            currentUser.saveInBackgroundWithBlock({ (saveSuccessful, error) in
                print("saved")
            })
        })
    }
}
