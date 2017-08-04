//
//  CartTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 03/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var serviceNameLabel: UILabel!
	@IBOutlet weak var noteTextView: UITextView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var professionalPictureImageView: UIImageView!
	@IBOutlet weak var editButton: UIButton!
	@IBOutlet weak var totalPriceLabel: UILabel!
	@IBOutlet weak var professionalNameLabel: UILabel!

	var subServices = [ScheduleSubService]()
	
	@IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			
			noteTextView.setBorder(width: 1, color: UIColor(hex: "515151"))
			editButton.round()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
