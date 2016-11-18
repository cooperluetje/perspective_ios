//
//  HeaderTableViewCell.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/15/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell
{
    // MARK: Properties
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
