//
//  VTAPollViewModel.swift
//  Vota
//
//  Created by Jose Alvarado on 2/16/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAPollViewModel: NSObject {

    class func votesAgreedOnPoll(poll: PFObject, success:() -> Void, failure: () -> Void) {
        poll.incrementKey("numberOfAgrees")
        poll.incrementKey("numberOfVotes")
        poll.saveInBackgroundWithBlock { (successful: Bool?, error: NSError?) -> Void in
            if let _ = successful {
                let vote = PFObject(className: "Vote")
                vote["user"] = PFUser.currentUser()
                vote["poll"] = poll
                vote["option"] = 0
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
    
    class func alreadyVotedOnPoll(poll: PFObject, voted: () -> Void, notVoted: () -> Void) {
        let query = PFQuery(className: "Vote")
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.whereKey("poll", equalTo: poll)
        query.getFirstObjectInBackgroundWithBlock { (voteObject: PFObject?, error: NSError?) -> Void in
            if let _ = voteObject {
                voted()
            } else if let _ = error {
                
            } else {
                notVoted()
            }
        }
    }
    
}
