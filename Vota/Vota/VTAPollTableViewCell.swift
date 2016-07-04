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

    
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var issueLabel: UILabel!

//    @IBOutlet weak var pollImageView: UIImageView!
//    @IBOutlet weak var pollImageHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var questionLabel: UILabel!
//    @IBOutlet weak var numberOfVotesLabel: UILabel!
//    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    
//    @IBOutlet weak var agreeView: UIView!
//    @IBOutlet weak var disagreeView: UIView!
//    @IBOutlet weak var unsureView: UIView!
    
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var disagreeButton: UIButton!
    
//    @IBOutlet weak var agreeLabel: UILabel!
//    @IBOutlet weak var disagreeLabel: UILabel!
//    @IBOutlet weak var unsureLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var percentageWidthConstraint: NSLayoutConstraint!
    weak var delegate: VTAPollTableViewCellDelegate?
    
    var poll: PFObject?
    var pollOption: PollOption?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.cornerRadius = 5
        
//        bottomView.layer.borderWidth = 1.0
//        bottomView.layer.borderColor = UIColor.grayColor().CGColor
//        
//        agreeView.layer.borderWidth = 1.0
//        agreeView.layer.borderColor = UIColor.grayColor().CGColor
//        
//        disagreeView.layer.borderWidth = 1.0
//        disagreeView.layer.borderColor = UIColor.grayColor().CGColor
//        
//        unsureView.layer.borderWidth = 1.0
//        unsureView.layer.borderColor = UIColor.grayColor().CGColor
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func agreeButtonPressed(sender: AnyObject) {
        guard let poll = self.poll else { return }

        self.agreeButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
        self.disagreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        
        VTAPollController.votesOnPollWithOption(poll, option: PollOption.Agreed, success: { () -> Void in
            print("Successfully voted agree")
            
            // backup
            self.pollOption = PollOption.Agreed
            self.updateVotes(PollOption.Agreed)
            }) { () -> Void in
                print("Failed to vote agree")
                
                if let pollOption = self.pollOption where pollOption == PollOption.Agreed{
                    self.agreeButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
                    self.disagreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                } else if let pollOption = self.pollOption where pollOption == PollOption.Disagree{
                    self.agreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                    self.disagreeButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
                } else {
                    self.agreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                    self.disagreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                }
        }
    }
    
    @IBAction func disagreeButtonPressed(sender: AnyObject) {
        guard let poll = self.poll else { return }

        self.agreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.disagreeButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
        
        VTAPollController.votesOnPollWithOption(poll, option: PollOption.Disagree, success: { () -> Void in
            print("Successfully voted disagree")
            
            // backup
            self.pollOption = PollOption.Disagree
            self.updateVotes(PollOption.Disagree)
            }) { () -> Void in
                print("Failed to vote disagree")
                if let pollOption = self.pollOption where pollOption == PollOption.Agreed{
                    self.agreeButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
                    self.disagreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                } else if let pollOption = self.pollOption where pollOption == PollOption.Disagree{
                    self.agreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                    self.disagreeButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
                } else {
                    self.agreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                    self.disagreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                }
        }
    }

    @IBAction func detailButtonPressed(sender: AnyObject) {
        guard let poll = self.poll else { return }

        let dict = ["type": "detail", "poll": poll]
        delegate?.pollSelected(dict)
    }
    
    func configureWithPollObject(poll: PFObject) {
        resultsView.hidden = true
        
        self.poll = poll
        
        if let issue = poll["issue_type"] as? String {
            issueLabel.text = issue.capatilizeEveryFirstCharacterOfEveryWord()
        }
        if let question = poll["question"] as? String {
            questionLabel.text = question
        }
        
        self.resultsView.hidden = true
        self.agreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.disagreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        
        VTAPollController.votedOptionOnPoll(poll, voted: { (option) in
            self.agreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            self.disagreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            self.resultsView.hidden = true
            self.pollOption = option
            VTAPollController.votesOnPoll(poll, votes: { (winner, percentage) in
                if option == PollOption.Agreed {
                    self.agreeButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
                    self.disagreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                } else if option == PollOption.Disagree {
                    self.agreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                    self.disagreeButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
                }
                
                var text = ""
                
                if winner == .Agreed {
                    text = "\(percentage)% Agreed"
                } else {
                    text = "\(percentage)% Disagreed"
                }
                
                self.resultsLabel.text = text
                
                let width = self.frame.width - 46
                
                self.percentageWidthConstraint.constant = width * CGFloat(percentage) / 100
                self.resultsView.hidden = false
            })
        }) {
            self.resultsView.hidden = true
        }
    }
    
    func fixScore(firstScore: Int, totalScore: Int) -> Int {
        if firstScore == 0 {
            return 0
        } else if firstScore == totalScore {
            return 100
        }
        
        return Int(1.0 * Double(firstScore) / Double(totalScore) * 100)
    }
    
    func updateVotes(option: PollOption) {
        guard let poll = self.poll else { return }

        VTAPollController.votesOnPoll(poll, votes: { (winner, percentage) in
            if option == PollOption.Agreed {
                self.agreeButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
                self.disagreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            } else if option == PollOption.Disagree {
                self.agreeButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                self.disagreeButton.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
            }
            
            var text = ""
            
            if winner == .Agreed {
                text = "\(percentage)% Agreed"
            } else {
                text = "\(percentage)% Disagreed"
            }
            
            self.resultsLabel.text = text
            
            let width = self.frame.width - 46
            
            self.percentageWidthConstraint.constant = width * CGFloat(percentage) / 100
            self.resultsView.hidden = false
        })
    }
    
    func capatilizeEveryFirstCharacterOfEveryWord (text: String) -> String {
        
        let split = text.componentsSeparatedByString(" ")
        var newWord = ""
        
        for var word in split {
            word.replaceRange(word.startIndex...word.startIndex, with: String(word[word.startIndex]).capitalizedString)
            newWord += word + " "
        }
        
        
        return newWord
    }

}
