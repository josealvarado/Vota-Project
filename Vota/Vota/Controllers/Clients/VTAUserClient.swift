//
//  VTAUserClient.swift
//  Vota
//
//  Created by Jose Alvarado on 3/1/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAUserClient: NSObject {

    class func userObjects(success: (users: [PFObject]) -> Void, failure: (error: NSError) -> Void) {
        let query = PFUser.query()
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (usersObjects: [AnyObject]?, error: NSError?) -> Void in
            if let usersObjects = usersObjects {
                let users = usersObjects as! [PFObject]
                success(users: users)
            } else if let error = error {
                failure(error: error)
            }
        }
    }
}
