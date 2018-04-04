//
//  SubServiceTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 27/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class SubServiceTableViewCell: UITableViewCell {

	@IBOutlet weak var tableView: UITableView!
	
	let services = [Service]()
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(UINib(nibName: "AdditionalServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionalServiceTableViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension SubServiceTableViewCell: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return services.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalServiceTableViewCell") as! AdditionalServiceTableViewCell
		
		let service = services[indexPath.row]
		
		cell.nameLabel.text = service.name
		cell.priceLabel.text = String(format: "%.2f", service.price)
		
		return cell
	}
}
