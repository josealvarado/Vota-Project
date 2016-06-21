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
        
        
        VTAPollController.alreadyVotedOnPoll(poll, voted: { (pollOption) in
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
    
    class func alreadyVotedOnPoll(poll: PFObject, voted: (pollOption: PollOption) -> Void, notVoted: () -> Void) {
        let query = PFQuery(className: "Vote")
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.whereKey("poll", equalTo: poll)
        query.getFirstObjectInBackgroundWithBlock { (voteObject: PFObject?, error: NSError?) -> Void in
            if let voteObeject = voteObject {
                guard let option = voteObeject["option"] as? Int else { return }
                if let pollOption = PollOption(rawValue: option) {
                    voted(pollOption: pollOption)
                }
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
    
    class func votedOptionOnPoll(poll: PFObject, voted: (option: PollOption) -> Void, notVoted: () -> Void) {
        let query = PFQuery(className: "Vote")
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.whereKey("poll", equalTo: poll)
        query.getFirstObjectInBackgroundWithBlock { (voteObject: PFObject?, error: NSError?) -> Void in
            if let voteObject = voteObject, option = voteObject["option"] as? Int {
                if option == 0 {
                    voted(option: .Agreed)
                } else if option == 1 {
                    voted(option: .Disagree)
                }
            } else {
                notVoted()
            }
        }
    }
    
    class func numberOfPollsVotedOnByUser(user: PFUser, results: (count: Int) -> Void) {
        let query = PFQuery(className: "Vote")
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.countObjectsInBackgroundWithBlock {
            (pollCount: Int32, error: NSError?) -> Void in

            if let _ = error {
                results(count: 0)
            } else {
                results(count: Int(pollCount))
            }
        }
    }
    
    class func votesOnPoll(poll: PFObject, votes: (winner: PollOption, percentage: Int) -> Void) {
        let query = PFQuery(className:"Vote")
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.whereKey("poll", equalTo: poll)
        query.whereKey("option", equalTo: 0)
        query.countObjectsInBackgroundWithBlock {
            (agreeCount: Int32, error: NSError?) -> Void in
            if error == nil {
                print("Agree count \(agreeCount)")
                
                
                
                
                
                let query2 = PFQuery(className:"Vote")
                query2.whereKey("user", equalTo: PFUser.currentUser())
                query2.whereKey("poll", equalTo: poll)
                query2.whereKey("option", equalTo: 1)
                query2.countObjectsInBackgroundWithBlock {
                    (disagreeCount: Int32, error: NSError?) -> Void in
                    if error == nil {
                        print("Disagree count \(disagreeCount)")
                        let totalCount = agreeCount + disagreeCount
                        if agreeCount > disagreeCount {
//                            let percent = Double(agreeCount) / Double((agreeCount + disagreeCount))
                            let percent = self.fixScore(Int(agreeCount), totalScore: Int(totalCount))
//                            let percent = self.fixScore(

                            print("Agree per \(percent)")
                            
                            votes(winner: .Agreed, percentage: percent)
                        } else {
                            let percent = self.fixScore(Int(disagreeCount), totalScore: Int(totalCount))
                            print("Disagree per \(percent)")
                            votes(winner: .Disagree, percentage: percent)
                        }
                    }
                }
            }
        }
    }
    
    class func fixScore(firstScore: Int, totalScore: Int) -> Int {
        if firstScore == 0 {
            return 0
        } else if firstScore == totalScore {
            return 100
        }
        
        return Int(1.0 * Double(firstScore) / Double(totalScore) * 100)
    }
    
//    class func numberOfPollsByUser(user: PFUser, pollCOunt: (count: Int) -> Void) {
//        let query = PFQuery(className:"Vote")
//        query.whereKey("user", equalTo: user)
//        query.countObjectsInBackgroundWithBlock {
//            (pollCount: Int32, error: NSError?) -> Void in
//            if error == nil {
//                print("numberOfPollsMade \(pollCount)")
//                
//                pollCOunt(count: Int(pollCount))
//            } else {
//                pollCOunt(count: 0)
//            }
//        }
//    }
    
    
    
}