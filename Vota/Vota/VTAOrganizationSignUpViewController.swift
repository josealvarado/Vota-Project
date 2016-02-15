//
//  VTAOrganizationSignUpViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 2/8/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAOrganizationSignUpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate  {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var inputViews: [UIView]!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var partyTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    var activeTextField: UITextField!
    
    var activeInputArray: [String] = []
    var party : [String] = ["Democrat","Republican","Independent"];
    var pronouns : [String] = ["Man","Women","Trans*"];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Changing the Status Bar to White
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        // Setup notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification, object: nil)
        
        // Setup dissmiss keyboard tap getsture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        setupPickerViews()
        
        addBorderToViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInset
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func addBorderToViews() {
        for view in inputViews {
            view.layer.borderColor = UIColor.grayColor().CGColor
            view.layer.borderWidth = 0.5
        }
    }
    
    func setupPickerViews() {
        let picker = UIPickerView()
        picker.delegate   = self
        picker.dataSource = self
        
        partyTextField.inputView = picker
    }
    
    // MARK: - User interactions
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        
        VTAProfileController.registerNewOrganization(nameTextField.text, email: emailTextField.text, phoneNumber: phoneNumberTextField.text, party: partyTextField.text, password: passwordTextField.text, passwordCopy: retypePasswordTextField.text,
            success: { () -> Void in
            
                self.dismissViewControllerAnimated(true, completion: nil)
            
            }) { (error) -> Void in
                let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func webViewButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("webView", sender: sender.tag)
    }
    
    // MARK: - UIPickerView delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return activeInputArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return activeInputArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.activeTextField.text = self.activeInputArray[row];
        self.activeTextField.endEditing(true)
    }
    
    // MARK: - UITextField delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 6 {
            activeInputArray = party
            activeTextField = partyTextField
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "webView" {
            let webViewController = segue.destinationViewController as? VTAWebViewController
            if let tag = sender as? Int {
                if tag == 1 {
                    webViewController?.webString = "http://www.votaapp.com/"
                    webViewController?.titleString = "Privacy Policy"
                } else if tag == 2 {
                    webViewController?.webString = "http://www.votaapp.com/"
                    webViewController?.titleString = "Terms of Service"
                }
            }
        }
    }
}
