//
//  ReviewsHeaderTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 05/11/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import RateView

class ReviewsHeaderTableViewCell: UITableViewCell {
	
	@IBOutlet weak var rateView: RateView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		profileImageView.round()
		rateView.starFillColor = UIColor(hex: "F2C94C")
		rateView.starFillMode = .init(1)
		rateView.starSize = 13
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
