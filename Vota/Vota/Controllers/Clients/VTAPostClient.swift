//
//  VTAPostClient.swift
//  Vota
//
//  Created by Jose Alvarado on 2/15/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAPollClient: NSObject {
    
    class func polls(success: (polls: [PFObject]) -> Void, failure: (error: NSError) -> Void) {
        let query = PFQuery(className:"Poll")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (postObjects: [AnyObject]?, error: NSError?) -> Void in
            if let postObjects = postObjects {
                let polls = postObjects as! [PFObject]
                success(polls: polls)
            } else if let error = error {
                failure(error: error)
            }
        }
    }
    
    class func pollsWithIssue(issue: String, success: (polls: [PFObject]) -> Void, failure: (error: NSError) -> Void) {
        let query = PFQuery(className:"Poll")
        query.orderByDescending("createdAt")
        query.whereKey("issue_type", equalTo: issue)
        query.findObjectsInBackgroundWithBlock {
            (postObjects: [AnyObject]?, error: NSError?) -> Void in
            if let postObjects = postObjects {
                let polls = postObjects as! [PFObject]
                success(polls: polls)
            } else if let error = error {
                failure(error: error)
            }
        }
    }
    
    class func pollsByUser(user: PFUser, success: (polls: [PFObject]) -> Void, failure: (error: NSError) -> Void) {
        let query = PFQuery(className:"Poll")
        query.orderByDescending("createdAt")
        query.whereKey("user", equalTo: user)
        query.findObjectsInBackgroundWithBlock {
            (postObjects: [AnyObject]?, error: NSError?) -> Void in
            if let postObjects = postObjects {
                let polls = postObjects as! [PFObject]
                success(polls: polls)
            } else if let error = error {
                failure(error: error)
            }
        }
    }
    
    class func pollsVotedByUser(user: PFUser, success: (polls: [PFObject]) -> Void, failure: (error: NSError) -> Void) {
        let query = PFQuery(className:"Vote")
        query.orderByDescending("createdAt")
        query.includeKey("poll")
        query.whereKey("user", equalTo: user)
        query.findObjectsInBackgroundWithBlock {
            (postObjects: [AnyObject]?, error: NSError?) -> Void in
            if let postObjects = postObjects, polls = postObjects as? [PFObject] {
                
                var items = [PFObject]()
                for item in polls {
                    if let poll = item["poll"] as? PFObject {
                        items.append(poll)
                    }
                }
                
                success(polls: items)
            } else if let error = error {
                failure(error: error)
            }
        }
    }
}
