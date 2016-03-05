//
//  VTAInfoViewController.swift
//  Vota
//
//  Created by Jose Alvarado on 3/5/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAInfoViewController: UIViewController {

    @IBOutlet weak var repsView: UIView!
    @IBOutlet weak var candidateView: UIView!
    @IBOutlet weak var ballotsView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedOption = 0
    
    var selectedList = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - User Interactions
    @IBAction func repsButtonPressed(sender: AnyObject) {
        if selectedOption != 0 {
            selectedOption = 0
            
            repsView.backgroundColor = VTAStyleClass.darkBlueColor()
            candidateView.backgroundColor = UIColor.grayColor()
            ballotsView.backgroundColor = UIColor.grayColor()
            
//            self.selectedList = issues
//            self.tableView.reloadData()
        }
    }
    
    @IBAction func candidateButtonPressed(sender: AnyObject) {
        if selectedOption != 1 {
            selectedOption = 1
            
            repsView.backgroundColor = UIColor.grayColor()
            candidateView.backgroundColor = VTAStyleClass.darkBlueColor()
            ballotsView.backgroundColor = UIColor.grayColor()

//            VTAUserClient.userObjects({ (users) -> Void in
//                self.users = users
//                print("users found \(users.count)")
//                self.selectedList = users
//                self.tableView.reloadData()
//                }, failure: { (error) -> Void in
//                    print("VTASearchViewController, peopleButtonPressed, getting users : \(error)")
//            })
        }
    }
    
    @IBAction func baollotButtonPressed(sender: AnyObject) {
        if selectedOption != 2 {
            selectedOption = 2
            
            repsView.backgroundColor = UIColor.grayColor()
            candidateView.backgroundColor = UIColor.grayColor()
            ballotsView.backgroundColor = VTAStyleClass.darkBlueColor()

//            VTAUserClient.userObjects({ (users) -> Void in
//                self.users = users
//                print("users found \(users.count)")
//                self.selectedList = users
//                self.tableView.reloadData()
//                }, failure: { (error) -> Void in
//                    print("VTASearchViewController, peopleButtonPressed, getting users : \(error)")
//            })
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
