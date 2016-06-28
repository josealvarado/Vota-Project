//
//  VTACommentTableViewCell.swift
//  Vota
//
//  Created by Jose Alvarado on 2/28/16.
//  Copyright © 2016 ___Jose-Alvarado___. All rights reserved.
//

import UIKit

class VTACommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    var comment: PFObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWithCommentObject(comment: PFObject) {
        self.comment = comment
        
        if let user = comment["user"] as? PFUser, name = user["name"] as? String {
            usernameLabel.text = name
            
            if let image = user["image"] as? PFFile {
                image.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if let imageData = imageData, image = UIImage(data: imageData) {
                        self.userImageView.image = image
                    }
                })
            }
        }
        
        if let text = comment["text"] as? String {
            commentTextView.text = text
        }
        
    }
}
