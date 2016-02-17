//
//  VTAProfileController.swift
//  Vota
//
//  Created by Jose Alvarado on 1/27/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

enum ProfileType: Int {
    case Individual = 0, Organizaiton
}

class VTAProfileController: NSObject {
    
    class func isValidName(name: String?) -> Bool {
        if name == "" || name?.characters.count < 1 {
            return false
        }
        return true
    }
    
    class func isValidEmail(email: String?) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(email)
        return result
    }
    
    class func isValidPhoneNumber(phoneNumber: String?) -> Bool {
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(phoneNumber)
        return result
    }
    
    class func isValidPasswords(password: String?, secondPassword:String?) -> Bool {
        if let p1 = password, p2 = secondPassword  where p1 != "" && p2 != "" && p1 == p2 {
            return true
        }
        return false
    }
    
    class func registerNewIndividual(name:String?, email:String?, phoneNumber:String?, birthday:String?, gender:String?, party:String?, password:String?, passwordCopy:String?, referralKey:String?, success: () -> Void, failure: (error: String) -> Void) {
        
        if !isValidName(name) { return failure(error: "Invalid name") }
        if !isValidEmail(email) { return failure(error: "Invalid email") }
        if let birthday = party where birthday == "" { return failure(error: "Invalid birthday") }
        if let gender = party where gender == "" { return failure(error: "Invalid gender") }
        if let party = party where party == "" { return failure(error: "Invalid party") }
        if !isValidPhoneNumber(phoneNumber) { return failure(error: "Invalid phone number") }
        if !isValidPasswords(password, secondPassword: passwordCopy) {return failure(error: "Invalid password") }
        
        let user = PFUser()
        user.username = email!.lowercaseString
        user.password = password
        user.email = email!.lowercaseString
        user["name"] = name
        user["phone"] = phoneNumber
        user["birthday"] = birthday
        user["gender"] = gender
        user["party"] = party
        if let referralKey = referralKey where referralKey != "" {
            user["referralKey"] = referralKey
        }
        user["type"] = ProfileType.Individual.rawValue
        user["private"] = false
        user["linkedFB"] = false
        user.signUpInBackgroundWithBlock {
            (successful: Bool, error: NSError?) -> Void in
            if successful {
                print("successfully created an individual Parse account")
                return success()
            } else if let error = error {
                return failure(error: error.localizedDescription)
            }
        }
    }
    
    class func registerNewOrganization(name:String?, email:String?, phoneNumber:String?, party:String?, password:String?, passwordCopy:String?, success: () -> Void, failure: (error: String) -> Void) {
        
        if !isValidName(name) { return failure(error: "Invalid organizaation name") }
        if !isValidEmail(email) { return failure(error: "Invalid email") }
        if let party = party where party == "" { return failure(error: "Invalid party") }
        if !isValidPhoneNumber(phoneNumber) { return failure(error: "Invalid phone number") }
        if !isValidPasswords(password, secondPassword: passwordCopy) { return failure(error: "Invalid password") }
        
        let user = PFUser()
        user.username = email!.lowercaseString
        user.password = password
        user.email = email!.lowercaseString
        user["name"] = name
        user["phone"] = phoneNumber
        user["party"] = party
        user["type"] = ProfileType.Organizaiton.rawValue
        user["private"] = false
        user["linkedFB"] = false
        user.signUpInBackgroundWithBlock {
            (successful: Bool, error: NSError?) -> Void in
            if successful {
                print("successfully created an organization Parse account")
                success()
            } else if let error = error {
                failure(error: error.localizedDescription)
            }
        }
    }
    
    class func parseLogin(email: String, password: String, success: () -> Void, failure: (error: NSString) -> Void) {
        let query = PFUser.query()
        query?.whereKey("email", equalTo: email)
        query?.getFirstObjectInBackgroundWithBlock({ (userObject : PFObject?, error : NSError?) -> Void in
            if let userObject = userObject {
                let user = userObject as! PFUser
                let username = user.username
                
                self.login(username!, password: password, success: { () -> Void in
                    success()
                    }, failure: { (error) -> Void in
                        failure(error: error)
                })
            }
            else {
                self.login(email, password: password, success: { () -> Void in
                    success()
                    }, failure: { (error) -> Void in
                        failure(error: error)
                })
            }
        })
    }
    
    class func login(username : String, password : String, success: () -> Void, failure: (error: NSString) -> Void) {
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser?, error: NSError?) -> Void in
            if let _ = user {
                success()
            }
            else {
                if let error = error {
                    failure(error: error.localizedDescription)
                }
            }
        }
    }
}
