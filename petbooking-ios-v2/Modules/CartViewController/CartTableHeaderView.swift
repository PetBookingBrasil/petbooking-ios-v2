//
//  CartTableHeaderView.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 07/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class CartTableHeaderView: UIView {


	@IBOutlet weak var pictureImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var numberLabel: UILabel!

	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func draw(_ rect: CGRect) {
		// Drawing code
		
		pictureImageView.round()
	}
	
}
