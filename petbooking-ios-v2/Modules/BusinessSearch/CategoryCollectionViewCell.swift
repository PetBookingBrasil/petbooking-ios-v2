//
//  CategoryCollectionViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 11/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var pictureImageView: UIImageView!
	
	override var isSelected: Bool {
		didSet {
			if isSelected {
				pictureImageView.alpha = 1
				nameLabel.alpha = 1
				pictureImageView.dropShadow()
			} else {
				pictureImageView.alpha = 0.5
				nameLabel.alpha = 0.7
				pictureImageView.removeShadow()
			}
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
