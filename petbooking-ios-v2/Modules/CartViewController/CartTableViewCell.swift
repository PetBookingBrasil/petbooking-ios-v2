//
//  CartTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 03/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import RealmSwift

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

	var service:ScheduleService = ScheduleService()
	var subServices = List<ScheduleSubService>()
	
	weak var delegate:CartTableViewCellDelegate?
	
	@IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			
			noteTextView.setBorder(width: 1, color: UIColor(hex: "D8D8D8"))
			editButton.round()
			
			tableView.register(UINib(nibName: "CartTableSubServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableSubServiceTableViewCell")
			tableView.delegate = self
			tableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func reloadTable() {
		tableView.reloadData()
	}
	
	
	@IBAction func remove(_ sender: Any) {
		
		ScheduleManager.sharedInstance.deleteService(scheduleService: service)
		
		delegate?.update(service: service)
	}
    
}

extension CartTableViewCell : UITableViewDelegate, UITableViewDataSource, CartTableSubServiceTableViewCellDelegate {
	
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return subServices.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 30
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 20
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableSubServiceTableViewCell") as! CartTableSubServiceTableViewCell
		cell.delegate = self
		let subService = subServices[indexPath.row]
		
		cell.service = service
		cell.subService = subService
		
		cell.nameLabel.text = subService.name
		cell.priceLabel.text = String(format: "R$ %.2f", subService.price)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let label = UILabel()
		label.text = "   ADICIONAIS"
		label.font = UIFont.openSansSemiBold(ofSize: 9)
		label.textColor = UIColor(hex:"858585")
		
		return label
		
	}
	
	func didRemoveService(subService: ScheduleSubService) {
		
		tableView.reloadData()
		
		delegate?.update(service: service)
		
	}
	
}

protocol CartTableViewCellDelegate: class {
	
	
	func update(service:ScheduleService)
	
}
