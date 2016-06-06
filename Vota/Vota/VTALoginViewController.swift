//
//  VTALoginViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 1/24/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTALoginViewController: UIViewController {

//    @IBOutlet weak var emailView: UIView!
//    @IBOutlet weak var emailAddressTextField: UITextField!
//    @IBOutlet weak var passwordView: UIView!
//    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginViewEmailTextField: UITextField!
    @IBOutlet weak var loginViewPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var signUpViewEmailTextField: UITextField!
    @IBOutlet weak var signUpViewPasswordTextField: UITextField!
    @IBOutlet weak var signUpViewNameTextField: UITextField!
    @IBOutlet weak var signUpViewZipCodeTextField: UITextField!
    @IBOutlet weak var signUpViewBioTextView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        //        emailView.layer.borderColor = UIColor.grayColor().CGColor
//        emailView.layer.borderWidth = 1
//        
//        passwordView.layer.borderColor = UIColor.grayColor().CGColor
//        passwordView.layer.borderWidth = 1
        
//         Setup dissmiss keyboard tap getsture
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VTALoginViewController.DismissKeyboard))
//        self.view.addGestureRecognizer(tap)
//        tap.cancelsTouchesInView = false
        
        signUpButton.layer.cornerRadius = 5
        loginButton.layer.cornerRadius = 5
        
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
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    // MARK: - Registration View Actions
    
    @IBAction func registrationViewSignUpButtonPressed(sender: AnyObject) {
        registrationView.hidden = true
        loginView.hidden = true
        signUpView.hidden = false
    }
    @IBAction func registrationViewLoginButtonPressed(sender: AnyObject) {
        registrationView.hidden = true
        loginView.hidden = false
        signUpView.hidden = true
    }

    // MARK: - Login View Actions
    @IBAction func loginViewBackButtonPressed(sender: AnyObject) {
        registrationView.hidden = false
        loginView.hidden = true
        signUpView.hidden = true
    }
    @IBAction func loginViewLoginButtonPressed(sender: AnyObject) {
        guard let email = loginViewEmailTextField.text where email != "" else { return }
        guard let password = loginViewPasswordTextField.text where password != "" else { return }
        
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        VTAProfileController.parseLogin(email, password: password, success: {
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let tabViewController = self.storyboard!.instantiateViewControllerWithIdentifier("HomeTabBarController")
            self.presentViewController(tabViewController, animated: false, completion: {
                self.registrationView.hidden = false
                self.loginView.hidden = true
            })
            
            }) { (error) in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                let alertController = UIAlertController(title: "Error", message:
                    "\(error.description)", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpViewBackButtonPressed(sender: UIButton) {
        registrationView.hidden = false
        loginView.hidden = true
        signUpView.hidden = true
    }
    
    @IBAction func signUpViewCreateButtonPressed(sender: UIButton) {
        guard let email = signUpViewEmailTextField.text where email != "" else { return }
        guard let password = signUpViewPasswordTextField.text where password != "" else { return }
        guard let name = signUpViewNameTextField.text where name != "" else { return }
        guard let zipCode = signUpViewZipCodeTextField.text where zipCode != "" else { return }
        let bio = signUpViewZipCodeTextField.text ?? ""
        
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        VTAProfileController.registerNewUser(name, email: email, password: password, zipCode: zipCode, bio: bio, success: {
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            let tabViewController = self.storyboard!.instantiateViewControllerWithIdentifier("HomeTabBarController")
            self.presentViewController(tabViewController, animated: false, completion: {
                self.registrationView.hidden = false
                self.loginView.hidden = true
            })
            }) { (error) in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
