//
//  ServiceTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 26/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import BEMCheckBox
import RealmSwift

class ServiceTableViewCell: UITableViewCell {

	@IBOutlet weak var checkBox: BEMCheckBox!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	weak var delegate:ServiceTableViewDelegate?
	var service:Service! = Service()
	var subServices:List<ScheduleSubService> = List<ScheduleSubService>()
	
	@IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			checkBox.boxType = .square
			checkBox.delegate = self
			
			tableView.register(UINib(nibName: "AdditionalServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionalServiceTableViewCell")
			tableViewHeightConstraint.constant = CGFloat(subServices.count * 40)
			tableView.delegate = self
			tableView.dataSource = self
			
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
		tableViewHeightConstraint.constant = CGFloat(subServices.count * 40)
		tableView.reloadData()
	}
    
}

extension ServiceTableViewCell : UITableViewDelegate, UITableViewDataSource {
	

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return subServices.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalServiceTableViewCell") as! AdditionalServiceTableViewCell
		cell.delegate = self
		let subService = subServices[indexPath.row]
		let service:SubService! = SubService()
		service.id = subService.subServiceId
		service.name = subService.name
		
		cell.service = service
		
		cell.nameLabel.text = subService.name
		cell.priceLabel.text = String(format: "R$ %.2f", subService.price)
		
		return cell
	}
	
}

extension ServiceTableViewCell:AdditionalServiceTableViewDelegate {
	
	func didSelectedService(subService: SubService) {
		
		
		
	}
	
	func didUnselectedService(subService: SubService) {
		
		
		
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
