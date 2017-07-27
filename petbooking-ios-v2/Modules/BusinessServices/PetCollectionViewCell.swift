//
//  PetCollectionViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 24/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class PetCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var pictureImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			
			pictureImageView.round()
			
			pictureImageView.setBorder(width: 1, color: .red)
    }

}
