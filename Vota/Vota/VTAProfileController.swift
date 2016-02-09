//
//  VTAProfileController.swift
//  Vota
//
//  Created by Jose Alvarado on 1/27/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAProfileController: NSObject {
    
    class func isValidName(name: String) -> Bool {
        if name == "" {
            return false
        }
        return true
    }
    
    class func isValidEmail(email: String) -> Bool {
        return true
    }
    
    class func isValidPhoneNumber(phoneNumber: String) -> Bool {
        return true
    }
    
    class func isValidPasswords(password: String, secondPassword:String) -> Bool {
        return true
    }
    
    class func registerNewIndividual(name:String?, email:String?, phoneNumber:String?, birthday:String?, gender:String?, party:String?, password:String?, passwordCopy:String?, referralKey:String?, success: () -> Void, failure: (error: String) -> Void) {
        
        
        let user = PFUser()
        user.username = email!.lowercaseString
        user.password = password
        user.email = email!.lowercaseString
        user["name"] = name
        user["private"] = false
        user["linkedFB"] = false
        user.signUpInBackgroundWithBlock {
            (successful: Bool, error: NSError?) -> Void in
            if successful {
                print("successfully created an individual Parse account")
                return success()
            }
            
            if let error = error {
                return failure(error: error.localizedDescription)
            } else {
                return failure(error: "Failed to create user. Please try again later")
            }
        }
    }
    
    class func registerNewOrganization(name:String?, email:String?, phoneNumber:String?, party:String?, password:String?, passwordCopy:String?, success: () -> Void, failure: (error: String) -> Void) {
        
        
        let user = PFUser()
        user.username = email!.lowercaseString
        user.password = password
        user.email = email!.lowercaseString
        user["name"] = name
        user["private"] = false
        user["linkedFB"] = false
        user.signUpInBackgroundWithBlock {
            (successful: Bool, error: NSError?) -> Void in
            if successful {
                print("successfully created an organization Parse account")
                return success()
            }
            
            if let error = error {
                return failure(error: error.localizedDescription)
            } else {
                return failure(error: "Failed to create user. Please try again later")
            }
        }
    }
}
