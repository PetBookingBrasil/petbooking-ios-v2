//
//  MyPetsTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 20/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class MyPetsTableViewCell: UITableViewCell {

	@IBOutlet weak var petPictureImageView: UIImageView!
	
	@IBOutlet weak var petNameLabel: UILabel!
	@IBOutlet weak var petBreedLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			
			petPictureImageView.round()
			petPictureImageView.setBorder(width: 2, color: UIColor(hex: "FF4B4B"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
}
