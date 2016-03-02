//
//  VTAProfileTableViewCell.swift
//  Vota
//
//  Created by Jose Alvarado on 3/1/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

protocol VTAProfileTableViewCellDelegate: class {
    func profileCellSelected(dict: [String: AnyObject])
}

class VTAProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    weak var delegate:VTAProfileTableViewCellDelegate?
    
    var user: PFUser!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithProfile(user: PFUser) {
        self.user = user
        
        if let imageFile = user["image"] as? PFFile {
            imageFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.profileImageView.image = image
                    })
                }
            })
        }
        
        
    }
    
    // MARK: User Interactions
    
    @IBAction func profileButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func emailButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func registeredToVoteButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func viewVotingHistoryButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func viewFollowersButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func viewFollowingButtonPressed(sender: AnyObject) {
    }
}
