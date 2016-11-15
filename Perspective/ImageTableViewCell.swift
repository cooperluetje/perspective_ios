//
//  ImageTableViewCell.swift
//  Perspective
//
//  Created by Cooper Luetje on 11/15/16.
//  Copyright © 2016 Cooper Luetje. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell
{
    // MARK: Properties
    @IBOutlet weak var mainImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
