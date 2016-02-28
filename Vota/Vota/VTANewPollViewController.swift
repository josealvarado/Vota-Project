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
    @IBOutlet weak var wordCountLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    var issues = ["guns", "immigration"]
    
    let placeHolderText = "Write a question ..."
    let wordCount = 150
    
    var imageSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()

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
        imageSelected = false
    }
    
    // MARK: - User Interactions
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func includeImageButtonPressed(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
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
        if imageSelected {
            let imageOneData = UIImageJPEGRepresentation(imageView.image!, 0.5)
            if let imageOneData = imageOneData {
                let imageOneFile = PFFile(name: "imageOne.png", data: imageOneData)
                post["image"] = imageOneFile
            }
        }
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
            
            wordCountLabel.text = "\(newLength)"
            
            if text == "" {
                wordCountLabel.text = "\(wordCount)"
            }
        } else {
            if range.length == 1 {
                wordCountLabel.text = "\(wordCount - textView.text.characters.count + 1)"
            } else {
                wordCountLabel.text = "\(wordCount - textView.text.characters.count + range.length)"
            }
        }
        
        return true
    }
    
    // MARK: - SelectImageViewControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.imageView.image = image
                self.imageSelected = true
            }
        })
    }
}
