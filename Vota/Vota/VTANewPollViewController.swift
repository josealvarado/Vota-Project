//
//  VTANewPollViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 2/15/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTANewPollViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var issueTextField: UITextField!
    @IBOutlet weak var questionTextView: UITextView!
    
    var issues = ["guns", "immigration"]
    
    let placeHolderText = "Poll text."
    let wordCount = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        
        let picker = UIPickerView()
        picker.delegate   = self
        picker.dataSource = self
        
        issueTextField.inputView = picker
        
        VTAIssueClient.issuesStrings({ (issues) -> Void in
            self.issues = issues
            }) { (error) -> Void in
                print("ERROR, NewPollViewController, getting issues : \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - User Interactions
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        guard let issue = issueTextField.text where issue != "" else { return }
        guard let question = questionTextView.text where question != "" else { return }
        
        let post = PFObject(className: "Poll")
        post["issue_type"] = issue
        post["question"] = question
        post["user"] = PFUser.currentUser()
        post["numberOfComments"] = 0
        post["numberOfVotes"] = 0
        post["numberOfAgrees"] = 0
        post["numberOfDisagrees"] = 0
        post["numberOfUnsures"] = 0
        post.saveInBackgroundWithBlock{(success: Bool, error: NSError?) -> Void in
            if success {
                self.navigationController?.popViewControllerAnimated(true)
            } else if let error = error {
                print("ERROR, NewPollViewController: \(error)")
            }
        }
    }
    
    // MARK: - UIPickerView delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return issues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return issues[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        issueTextField.text = issues[row];
        issueTextField.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UITextViewDelgate
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.questionTextView.textColor = UIColor.blackColor()
        
        if(self.questionTextView.text == placeHolderText) {
            self.questionTextView.text = ""
        }
        
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if(textView.text == "") {
            self.questionTextView.text = placeHolderText
            self.questionTextView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        if range.length == 0 {
            let newLength = wordCount - textView.text.characters.count - 1
            if newLength < 0 {
                return false
            }
        }
        return true
    }
}
