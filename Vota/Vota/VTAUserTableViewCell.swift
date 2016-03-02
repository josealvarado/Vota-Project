//
//  VTAUserTableViewCell.swift
//  Vota
//
//  Created by Jose Alvarado on 3/1/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTAUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user:PFUser!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2;
        userImageView.clipsToBounds = true;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithUser(user: PFUser) {
        self.userImageView.image = UIImage(named: "defaultProfilePicture.png")
        
        self.user = user
        if let username = user.username {
            usernameLabel.text = username
        }
        
        if let imageFile = user["image"] as? PFFile {
            imageFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.userImageView.image = image
                    })
                }
            })
        }
    }
    
}
