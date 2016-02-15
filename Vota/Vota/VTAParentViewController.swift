//
//  VTAParentViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 2/10/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAParentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
//        if let _ = PFUser.currentUser() {
//            print("Login the user in")
//            let controller = storyboard?.instantiateViewControllerWithIdentifier("HomeTabBarController")
//            self.presentViewController(controller!, animated: true, completion: nil)
//            
//        } else {
//            print("there is no user logged in")
//            let controller = storyboard?.instantiateViewControllerWithIdentifier("VTALoginViewController") 
//            self.presentViewController(controller!, animated: true, completion: nil)
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if let _ = PFUser.currentUser() {
            print("B Login the user in")
            let controller = storyboard?.instantiateViewControllerWithIdentifier("HomeTabBarController")
            self.presentViewController(controller!, animated: true, completion: nil)
            
        } else {
            print("B there is no user logged in")
            let controller = storyboard?.instantiateViewControllerWithIdentifier("VTALoginViewNavController")
            self.presentViewController(controller!, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
