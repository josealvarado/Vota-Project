//
//  VTAEmailViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 3/6/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAEmailViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        textView.becomeFirstResponder()
    }
    
    // MARK: - User Interaction
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        let message = textView.text
        if message == "" {
            return
        }
        let feedback = PFObject(className: "Feedback")
        feedback["user"] = PFUser.currentUser()
        feedback["message"] = message
        feedback.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
            if success {
                self.navigationController?.popViewControllerAnimated(true)
            } else if let error = error {
                print("VTAEmailViewController, sendButtonPressed: \(error)")
            }
        }
    }
}
