//
//  VTAPollTableViewCell.swift
//  Vota
//
//  Created by Jose Alvarado on 2/15/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

protocol VTAPollTableViewCellDelegate: class {
    func pollSelected(dict: [String: AnyObject])
}

class VTAPollTableViewCell: UITableViewCell {

    @IBOutlet weak var issueLabel: UILabel!

    @IBOutlet weak var pollImageView: UIImageView!
    @IBOutlet weak var pollImageHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var numberOfVotesLabel: UILabel!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    
    @IBOutlet weak var agreeView: UIView!
    @IBOutlet weak var disagreeView: UIView!
    @IBOutlet weak var unsureView: UIView!
    
    
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var disagreeLabel: UILabel!
    @IBOutlet weak var unsureLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    weak var delegate: VTAPollTableViewCellDelegate?
    
    var poll: PFObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bottomView.layer.borderWidth = 1.0
        bottomView.layer.borderColor = UIColor.grayColor().CGColor
        
        agreeView.layer.borderWidth = 1.0
        agreeView.layer.borderColor = UIColor.grayColor().CGColor
        
        disagreeView.layer.borderWidth = 1.0
        disagreeView.layer.borderColor = UIColor.grayColor().CGColor
        
        unsureView.layer.borderWidth = 1.0
        unsureView.layer.borderColor = UIColor.grayColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func agreeButtonPressed(sender: AnyObject) {
        VTAPollController.votesOnPollWithOption(poll, option: PollOption.Agreed, success: { () -> Void in
            print("Successfully voted disagree")
            self.updateVotes()
            }) { () -> Void in
                print("Failed to vote disagree")
        }
    }
    
    @IBAction func disagreeButtonPressed(sender: AnyObject) {
        VTAPollController.votesOnPollWithOption(poll, option: PollOption.Disagree, success: { () -> Void in
            print("Successfully voted disagree")
            self.updateVotes()
            }) { () -> Void in
                print("Failed to vote disagree")
        }
    }
    
    @IBAction func unsureButtonPressed(sender: AnyObject) {
        VTAPollController.votesOnPollWithOption(poll, option: PollOption.Unsure, success: { () -> Void in
            print("Successfully voted disagree")
            self.updateVotes()
            }) { () -> Void in
                print("Failed to vote disagree")
        }
    }
    
    @IBAction func detailButtonPressed(sender: AnyObject) {
        let dict = ["type": "detail", "poll": poll]
        delegate?.pollSelected(dict)
    }
    
    func configureWithPollObject(poll: PFObject) {
        self.pollImageHeightConstraint.constant = 1
        self.poll = poll
        
        VTAPollController.votedOptionOnPoll(poll) { (option) -> Void in
            if option == PollOption.Agreed {
                self.agreeLabel.textColor = UIColor.blueColor()
            } else if option == PollOption.Disagree {
                self.disagreeLabel.textColor = UIColor.blueColor()
            } else if option == PollOption.Unsure {
                self.unsureLabel.textColor = UIColor.blueColor()
            }
        }
        
        if let imageFile = poll["image"] as? PFFile {
            imageFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.pollImageHeightConstraint.constant = 124
                    let image = UIImage(data:imageData!)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.pollImageView.image = image
                    })
                }
            })
        }
        
        if let issue = poll["issue_type"] as? String {
            issueLabel.text = issue
        }
        if let question = poll["question"] as? String {
            questionLabel.text = question
        }
        if let numberOfComments = poll["numberOfComments"] as? Int {
            numberOfCommentsLabel.text = "\(numberOfComments)"
        }
        updateVotes()
    }
    
    func fixScore(firstScore: Int, totalScore: Int) -> Int {
        if firstScore == 0 {
            return 0
        } else if firstScore == totalScore {
            return 100
        }
        
        return Int(1.0 * Double(firstScore) / Double(totalScore) * 100)
    }
    
    func updateVotes() {
        if let numberOfVotes = poll["numberOfVotes"] as? Int where numberOfVotes != 0 {
            numberOfVotesLabel.text = "\(numberOfVotes)"
            
            if let numberOfAgrees = poll["numberOfAgrees"] as? Int {
                agreeLabel.text = "\(fixScore(numberOfAgrees, totalScore: numberOfVotes))%"
            }
            if let numberOfDisagrees = poll["numberOfDisagrees"] as? Int {
                disagreeLabel.text = "\(fixScore(numberOfDisagrees, totalScore: numberOfVotes))%"
            }
            if let numberOfUnsures = poll["numberOfUnsures"] as? Int {
                unsureLabel.text = "\(fixScore(numberOfUnsures, totalScore: numberOfVotes))%"
            }
        } else {
            numberOfVotesLabel.text = "0"
            agreeLabel.text = "0%"
            disagreeLabel.text = "0%"
            unsureLabel.text = "0%"
        }
    }
}
