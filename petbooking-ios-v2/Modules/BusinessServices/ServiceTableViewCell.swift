//
//  ServiceTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 26/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import BEMCheckBox

class ServiceTableViewCell: UITableViewCell {

	@IBOutlet weak var checkBox: BEMCheckBox!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	
	weak var delegate:ServiceTableViewDelegate?
	
	var service:Service! = Service()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			checkBox.boxType = .square
			checkBox.delegate = self
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 10, 0))
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func reloadTable() {
	}
    
}



extension ServiceTableViewCell : BEMCheckBoxDelegate {
	
	func didTap(_ checkBox: BEMCheckBox) {
		
		if checkBox.on {
			self.delegate?.didSelectedService(service: self.service)
		} else {
			self.delegate?.didUnselectedService(service: self.service)
		}
		
	}
	
}

protocol ServiceTableViewDelegate: class {
	
	
	func didSelectedService(service:Service)
	
	func didUnselectedService(service:Service)
	
	
}
