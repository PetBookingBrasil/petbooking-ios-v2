//
//  AdditionalServiceTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 26/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import BEMCheckBox

class AdditionalServiceTableViewCell: UITableViewCell {

	@IBOutlet weak var checkBox: BEMCheckBox!
	@IBOutlet weak var nameLabel: UILabel!	
	@IBOutlet weak var priceLabel: UILabel!
	weak var delegate:AdditionalServiceTableViewDelegate?
	
	var service:SubService = SubService()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			checkBox.boxType = .circle
			checkBox.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension AdditionalServiceTableViewCell : BEMCheckBoxDelegate {
	
	func didTap(_ checkBox: BEMCheckBox) {
		
		if checkBox.on {
			self.delegate?.didSelectedService(subService: self.service)
		} else {
			self.delegate?.didUnselectedService(subService: self.service)
		}
		
	}
	
}

protocol AdditionalServiceTableViewDelegate: class {
	
	
	func didSelectedService(subService:SubService)
	
	func didUnselectedService(subService:SubService)

}
