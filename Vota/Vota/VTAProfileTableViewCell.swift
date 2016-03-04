//
//  VTAProfileTableViewCell.swift
//  Vota
//
//  Created by Jose Alvarado on 3/1/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

protocol VTAProfileTableViewCellDelegate: class {
    func profileCellSelected(dict: [String: AnyObject])
}

class VTAProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var voteView: UIView!
    @IBOutlet weak var voteImageView: UIImageView!
    @IBOutlet weak var voteLabel: UILabel!
    
    @IBOutlet weak var pollView: UIView!
    @IBOutlet weak var pollLabel: UILabel!
    
    @IBOutlet weak var followersView: UIView!
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var followingView: UIView!
    @IBOutlet weak var followingLabel: UILabel!
    
    weak var delegate:VTAProfileTableViewCellDelegate?
    
    var user: PFUser!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        emailView.layer.borderColor = UIColor.grayColor().CGColor
        emailView.layer.borderWidth = 1.0
        
        voteView.layer.borderColor = UIColor.grayColor().CGColor
        voteView.layer.borderWidth = 1.0
        
        pollView.layer.borderColor = VTAStyleClass.darkBlueColor().CGColor
        pollView.layer.borderWidth = 1.0
        
        followersView.layer.borderColor = VTAStyleClass.darkBlueColor().CGColor
        followersView.layer.borderWidth = 1.0
        
        followingView.layer.borderColor = VTAStyleClass.darkBlueColor().CGColor
        followingView.layer.borderWidth = 1.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithProfile(user: PFUser) {
        self.user = user
        
        if let imageFile = user["image"] as? PFFile {
            imageFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.profileImageView.image = image
                    })
                }
            })
        }
        
        if let verified = user["emailVerified"] as? Bool where verified == true {
            emailImageView.image = emailImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            emailImageView.tintColor = VTAStyleClass.darkBlueColor()
            
            emailLabel.text = "Verified email"
            emailLabel.textColor = VTAStyleClass.darkBlueColor()
        } else {
            emailImageView.image = emailImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            emailImageView.tintColor = UIColor.grayColor()
            
            emailLabel.text = "Verify your email now!"
            emailLabel.textColor = UIColor.grayColor()
        }
        
        if let verified = user["voterVerified"] as? Bool where verified == true {
            voteImageView.image = voteImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            voteImageView.tintColor = VTAStyleClass.darkBlueColor()
            
            voteLabel.text = "Verified voter"
            voteLabel.textColor = VTAStyleClass.darkBlueColor()
        } else {
            voteImageView.image = voteImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            voteImageView.tintColor = UIColor.grayColor()
            
            voteLabel.text = "Register to vote now!"
            voteLabel.textColor = UIColor.grayColor()
        }
        
        VTAUserClient.numberOfPollsForUser(user, success: { (count) -> Void in
            self.pollLabel.text = "\(count) Polls"
            }) { (error) -> Void in
                print("VTAProfileTableViewCell, configureCellWithProfile, numberOfPollsForUser: \(error)")
        }
        
        VTAUserClient.numberOfFollowersForUser(user, success: { (count) -> Void in
            self.followersLabel.text = "\(count) Followers"
            }) { (error) -> Void in
                print("VTAProfileTableViewCell, configureCellWithProfile, numberOfFollowersForUser: \(error)")
        }
        
        VTAUserClient.numberOfFollowingForUser(user, success: { (count) -> Void in
            self.followingLabel.text = "\(count) Following"
            }) { (error) -> Void in
                print("VTAProfileTableViewCell, configureCellWithProfile, numberOfFollowingForUser: \(error)")
        }
    }
    
    // MARK: User Interactions
    
    @IBAction func profileButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func emailButtonPressed(sender: AnyObject) {
        print("verify your email now!")
    }
    
    @IBAction func registeredToVoteButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func viewVotingHistoryButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func viewFollowersButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func viewFollowingButtonPressed(sender: AnyObject) {
    }
}
