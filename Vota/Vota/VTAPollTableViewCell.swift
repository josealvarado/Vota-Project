//
//  VTAPollTableViewCell.swift
//  Vota
//
//  Created by Jose Alvarado on 2/15/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAPollTableViewCell: UITableViewCell {

    @IBOutlet weak var issueLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var numberOfVotesLabel: UILabel!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var disagreeLabel: UILabel!
    @IBOutlet weak var unsureLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    var poll: PFObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bottomView.layer.borderWidth = 1.0
        bottomView.layer.borderColor = UIColor.grayColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func agreeButtonPressed(sender: AnyObject) {
        VTAPollViewModel.votesAgreedOnPoll(poll, success: { () -> Void in
            print("success")
            self.updateVotes()
            }) { () -> Void in
                print("failure")
        }
    }
    
    @IBAction func disagreeButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func unsureButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func detailButtonPressed(sender: AnyObject) {
    }
    
    func configureWithPollObject(poll: PFObject) {
        self.poll = poll
        
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
