//
//  BusinessTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 24/06/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

	@IBOutlet weak var businessImageView: UIImageView!
	@IBOutlet weak var ratingLabel: UILabel!
	@IBOutlet weak var reviewQuantityLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var distanceView: UIView!
	@IBOutlet weak var distanceLabel: UILabel!
	@IBOutlet weak var favoriteButton: UIButton!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
