//
//  CartTableSubServiceTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 07/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class CartTableSubServiceTableViewCell: UITableViewCell {
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	weak var delegate:CartTableSubServiceTableViewCellDelegate?
	
	var service:ScheduleService = ScheduleService()
	var subService:ScheduleSubService = ScheduleSubService()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func remove(_ sender: Any) {
		
		ScheduleManager.sharedInstance.deleteSubService(scheduleSubService: subService, scheduleService: service)
		
		delegate?.didRemoveService(subService: subService)
	}
	
    
}

protocol CartTableSubServiceTableViewCellDelegate: class {
	
	
	func didRemoveService(subService:ScheduleSubService)
	
}

