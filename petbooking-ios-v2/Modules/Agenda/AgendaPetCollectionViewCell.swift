//
//  AgendaPetCollectionViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 03/11/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class AgendaPetCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var pictureImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
	override var isSelected: Bool {
		didSet {
			self.nameLabel.textColor = isSelected ? UIColor(hex: "E4002B") : UIColor(hex: "515151")
			if isSelected {
				pictureImageView.setBorder(width: 2, color: UIColor(hex: "E4002B"))
			} else {
				pictureImageView.setBorder(width: 0, color: UIColor.clear)
			}
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		pictureImageView.round()
    }

}
