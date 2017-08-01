//
//  TImeCollectionViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 31/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class TImeCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var timeContainer: UIView!
	@IBOutlet weak var timeLabel: UILabel!
	
	override var isSelected: Bool {
		didSet {
			if isSelected {
				timeLabel.textColor = UIColor.white
				timeContainer.setBorder(width: 0, color: UIColor(hex: "515151"))
				timeContainer.backgroundColor = UIColor(hex: "E4002B")
			} else {
				timeLabel.textColor = UIColor(hex: "515151")
				timeContainer.setBorder(width: 1, color: UIColor(hex: "515151"))
				timeContainer.backgroundColor = UIColor.white
			}
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			
			timeContainer.layer.cornerRadius = 4
			timeContainer.setBorder(width: 1, color: UIColor(hex: "515151"))
    }

}
