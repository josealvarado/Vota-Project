//
//  VTAIssueClient.swift
//  Vota
//
//  Created by Jose Alvarado on 2/16/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAIssueClient: NSObject {

    class func issuesObjects(success: (issues: [PFObject]) -> Void, failure: (error: NSError) -> Void) {
        let query = PFQuery(className:"Issue")
        query.orderByDescending("order")
        query.findObjectsInBackgroundWithBlock {
            (issueObjects: [AnyObject]?, error: NSError?) -> Void in
            if let issueObjects = issueObjects {
                let issues = issueObjects as! [PFObject]
                success(issues: issues)
            } else if let error = error {
                failure(error: error)
            }
        }
    }
    
    class func issuesStrings(success: (issues: [String]) -> Void, failure: (error: NSError) -> Void) {
        let query = PFQuery(className:"Issue")
        query.orderByDescending("order")
        query.findObjectsInBackgroundWithBlock {
            (issueObjects: [AnyObject]?, error: NSError?) -> Void in
            if let issueObjects = issueObjects as? [PFObject]{
                var issues = [String]()
                for issue in issueObjects {
                    if let name = issue["name"] as? String {
                        issues.append(name)
                    }
                }
                success(issues: issues)
            } else if let error = error {
                failure(error: error)
            }
        }
    }
}
