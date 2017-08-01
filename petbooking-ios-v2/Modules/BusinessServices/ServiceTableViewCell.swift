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
	@IBOutlet weak var tableView: UITableView!
	
	weak var delegate:ServiceTableViewDelegate?
	
	var service:Service! = Service()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			checkBox.boxType = .square
			checkBox.delegate = self
			tableView.delegate = self
			tableView.dataSource = self
			tableView.register(UINib(nibName: "AdditionalServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionalServiceTableViewCell")
			tableView.estimatedRowHeight = 2000
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
		tableView.reloadData()
	}
    
}

extension ServiceTableViewCell: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		
		return 1
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return service.services.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalServiceTableViewCell") as! AdditionalServiceTableViewCell
		
		let subService = service.services[indexPath.row]
		
		cell.nameLabel.text = subService.name
		cell.priceLabel.text = String(format: "R$ %.2f", subService.price)
		
		return cell
		
	}
	
}

extension ServiceTableViewCell : BEMCheckBoxDelegate {
	
	func didTap(_ checkBox: BEMCheckBox) {
		
		self.delegate?.didSelectedService(service: self.service)
		
	}
	
}

protocol ServiceTableViewDelegate: class {
	
	
	func didSelectedService(service:Service)
	
	
}
