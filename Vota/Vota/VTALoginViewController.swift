//
//  VTALoginViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 1/24/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTALoginViewController: UIViewController {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailView.layer.borderColor = UIColor.grayColor().CGColor
        emailView.layer.borderWidth = 1
        
        passwordView.layer.borderColor = UIColor.grayColor().CGColor
        passwordView.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignUpButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("Sign Up", sender: sender.tag)
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Sign Up" {

        }
    }


}
