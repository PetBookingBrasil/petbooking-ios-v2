//
//  TimeTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 31/10/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

	@IBOutlet weak var timeContainer: UIView!
	@IBOutlet weak var timeLabel: UILabel!
	
	override var isSelected: Bool {
		didSet {
			if isSelected {
				timeLabel.textColor = UIColor.white
				timeContainer.backgroundColor = UIColor(hex: "E4002B")
			} else {
				timeLabel.textColor = UIColor(hex: "515151")
				timeContainer.backgroundColor = UIColor.white
			}
		}
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		
		if selected {
			timeLabel.textColor = UIColor(hex: "E4002B")
			timeContainer.backgroundColor =  UIColor(hex: "E4002B").withAlphaComponent(0.1)

		} else {
			timeLabel.textColor = UIColor(hex: "515151")
			timeContainer.backgroundColor = UIColor.white
		}
		
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		
		timeContainer.round()
		
	}
    
}
