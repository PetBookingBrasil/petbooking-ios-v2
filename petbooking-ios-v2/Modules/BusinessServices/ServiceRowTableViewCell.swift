//
//  ServiceRowTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 22/10/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class ServiceRowTableViewCell: UITableViewCell {

	@IBOutlet weak var panelView: UIView!
	@IBOutlet weak var iconImageView: UIImageView!
	
	@IBOutlet weak var titleLabel: UILabel!
	
	var indexPath:IndexPath?
	
	weak var delegate:ServiceRowTableViewCellDelegate?
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		iconImageView.round()
		panelView.dropShadow()
		panelView.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func editAction(_ sender: Any) {
	
		guard let indexPath = self.indexPath else {
			return
		}
		
		delegate?.showContent(indexPath: indexPath)
		
	}
	
}

protocol ServiceRowTableViewCellDelegate: class {
	
	
	func showContent(indexPath:IndexPath)
	
}