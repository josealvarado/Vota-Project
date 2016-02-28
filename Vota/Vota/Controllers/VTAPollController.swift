//
//  VTAPollController.swift
//  Vota
//
//  Created by Jose Alvarado on 2/27/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

public enum PollOption: Int {
    case Agreed = 0, Disagree, Unsure
}

class VTAPollController: NSObject {
    
    class func votesOnPollWithOption(poll: PFObject, option:PollOption, success:() -> Void, failure: () -> Void) {
        VTAPollController.alreadyVotedOnPoll(poll, voted: { () -> Void in
            print("already voted on poll. Do nothing")
            }) { () -> Void in
                if option == .Agreed {
                    poll.incrementKey("numberOfAgrees")
                } else if option == .Disagree {
                    poll.incrementKey("numberOfDisagrees")
                } else if option == .Unsure {
                    poll.incrementKey("numberOfUnsures")
                }
                poll.incrementKey("numberOfVotes")
                poll.saveInBackgroundWithBlock { (successful: Bool?, error: NSError?) -> Void in
                    if let _ = successful {
                        let vote = PFObject(className: "Vote")
                        vote["user"] = PFUser.currentUser()
                        vote["poll"] = poll
                        vote["option"] = option.rawValue
                        vote.saveInBackgroundWithBlock { (successful: Bool?, error: NSError?) -> Void in
                            if let _ = successful {
                                success()
                            } else if let error = error {
                                print("ERROR, PollViewModel: \(error)")
                                failure()
                            }
                        }
                    } else if let error = error {
                        print("ERROR, PollViewModel: \(error)")
                        failure()
                    }
                }
        }
    }
    
    class func alreadyVotedOnPoll(poll: PFObject, voted: () -> Void, notVoted: () -> Void) {
        let query = PFQuery(className: "Vote")
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.whereKey("poll", equalTo: poll)
        query.getFirstObjectInBackgroundWithBlock { (voteObject: PFObject?, error: NSError?) -> Void in
            if let _ = voteObject {
                voted()
            } else if let error = error {
                if error.code == 101 {
                    // no results matched the query, which means the user has not voted on this poll yet
                    notVoted()
                }
            } else {
                notVoted()
            }
        }
    }
    
    class func votedOptionOnPoll(poll: PFObject, voted: (option: PollOption) -> Void) {
        let query = PFQuery(className: "Vote")
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.whereKey("poll", equalTo: poll)
        query.getFirstObjectInBackgroundWithBlock { (voteObject: PFObject?, error: NSError?) -> Void in
            if let voteObject = voteObject, option = voteObject["option"] as? Int {
                if option == 0 {
                    voted(option: .Agreed)
                } else if option == 1 {
                    voted(option: .Disagree)
                } else if option == 2 {
                    voted(option: .Unsure)
                }
            }
        }
    }
    
}