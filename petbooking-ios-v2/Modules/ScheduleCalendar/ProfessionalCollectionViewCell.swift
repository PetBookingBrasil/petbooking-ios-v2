//
//  ProfessionalCollectionViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 31/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class ProfessionalCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var profileImageView: UIImageView!
	
	override var isSelected: Bool {
		didSet {
			self.nameLabel.textColor = isSelected ? UIColor(hex: "E4002B") : UIColor(hex: "515151")
			if isSelected {
				profileImageView.setBorder(width: 2, color: UIColor(hex: "E4002B"))
			} else {
				profileImageView.setBorder(width: 0, color: UIColor.clear)
			}
		}
	}



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			
			profileImageView.round()
			
    }
	


}
