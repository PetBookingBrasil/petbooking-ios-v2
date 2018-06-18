//
//  AgendaTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 09/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class AgendaTableViewCell: UITableViewCell {

	@IBOutlet weak var businessLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var serviceNameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var professionalNameLabel: UILabel!
	@IBOutlet weak var professionalImageView: UIImageView!
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var cancelButton: UIButton!
	
	var subServices:[SubService] = [SubService]()
	var scheduledService:ScheduledService! = ScheduledService()
	
	weak var delegate:AgendaTableViewCellDelegate?
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
			tableView.register(UINib(nibName: "AgendaSubServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "AgendaSubServiceTableViewCell")
			tableView.delegate = self
			tableView.dataSource = self
			cancelButton.round()
			professionalImageView.round()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func reloadTable() {
		tableView.reloadData()
	}
	
	@IBAction func cancel(_ sender: Any) {
		
		delegate?.showCancelScheduledServiceAlert(scheduledService: scheduledService)
		
	}
	
    
}

extension AgendaTableViewCell : UITableViewDelegate, UITableViewDataSource {
	
	
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
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaSubServiceTableViewCell") as! AgendaSubServiceTableViewCell
		let subService = subServices[indexPath.row]
		
		cell.nameLabel.text = subService.name
		cell.priceLabel.text = String(format: "R$ %.2f", subService.price)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		let label = UILabel()
		label.text = "       ADICIONAIS"
		label.font = UIFont.robotoMedium(ofSize: 9)
		label.textColor = UIColor(hex:"858585")
		
		return label
		
	}
	
}

protocol AgendaTableViewCellDelegate: class {
	
	
	func showCancelScheduledServiceAlert(scheduledService:ScheduledService)
	
	
}
