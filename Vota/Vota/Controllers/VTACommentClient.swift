//
//  VTACommentClient.swift
//  Vota
//
//  Created by Jose Alvarado on 2/28/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTACommentClient: NSObject {

    class func commentObjectsForPoll(poll: PFObject, success: (comments: [PFObject]) -> Void, failure: (error: NSError) -> Void) {
        let query = PFQuery(className:"Comment")
        query.orderByDescending("createdAt")
        query.whereKey("poll", equalTo: poll)
        query.findObjectsInBackgroundWithBlock {
            (commentObjects: [AnyObject]?, error: NSError?) -> Void in
            if let commentObjects = commentObjects {
                let comments = commentObjects as! [PFObject]
                success(comments: comments)
            } else if let error = error {
                failure(error: error)
            }
        }
    }
}
