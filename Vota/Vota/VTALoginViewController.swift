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
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailView.layer.borderColor = UIColor.grayColor().CGColor
        emailView.layer.borderWidth = 1
        
        passwordView.layer.borderColor = UIColor.grayColor().CGColor
        passwordView.layer.borderWidth = 1
        
        // Setup dissmiss keyboard tap getsture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func signInButtonPressed(sender: AnyObject) {
        
        
        if emailAddressTextField.text != "" && passwordTextField.text != "" {
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            VTAProfileController.parseLogin(emailAddressTextField.text!, password: passwordTextField.text!,
                success: { () -> Void in
                    print("login successful")
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    
                    let tabViewController = self.storyboard!.instantiateViewControllerWithIdentifier("HomeTabBarController")
                    self.presentViewController(tabViewController, animated: false, completion: nil)
                    
                }, failure: { (error) -> Void in
                    print("login failed")
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    let alertController = UIAlertController(title: "Error", message:
                        "\(error.description)", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
            })
        }
        else {
            let alertController = UIAlertController(title: "Error", message:
                "Missing information", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

}
