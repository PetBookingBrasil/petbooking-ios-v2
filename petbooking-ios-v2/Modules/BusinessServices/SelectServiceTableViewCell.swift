//
//  SelectServiceTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 22/10/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import RealmSwift

class SelectServiceTableViewCell: UITableViewCell {

	var serviceList:ServiceList = ServiceList()
	var services = [Service]()
	var selectedServiceCategory:ServiceCategory = ServiceCategory()
	var selectedService:Service = Service()
	var selectedSubServices = [SubService]()
	var selectedPet:Pet = Pet()
	var business:Business = Business()
	
	weak var delegate:SelectServiceTableViewCellDelegate?
	
	@IBOutlet weak var continueButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		continueButton.round()
		numberLabel.round()
		numberLabel.setBorder(width: 1, color: UIColor(hex: "E4002B"))
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UINib(nibName: "ServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceTableViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func continueSchedule(_ sender: Any) {
		delegate?.setSelectedService(selectedService: selectedService, selectedSubServices: selectedSubServices)
	}
	
	
}

extension SelectServiceTableViewCell: UITableViewDelegate, UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {

		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return services.count

	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

		let service = services[indexPath.section]
		
		if selectedService.id.isBlank {
			return 61
		}

		
		let headerSize = selectedService.services.count > 0 ? 20 : 0

		return CGFloat(70 + headerSize + selectedService.services.count * 40)

	}

//	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//
//		let service = serviceList.services[section]
//
//		if ScheduleManager.sharedInstance.hasServiceFromSchedule(business: business, pet: selectedPet, serviceCategory: selectedServiceCategory, service: service) {
//			return 60
//		} else {
//			return 10
//		}
//	}

//	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//		let service = serviceList.services[section]
//
//		if ScheduleManager.sharedInstance.hasServiceFromSchedule(business: business, pet: selectedPet, serviceCategory: selectedServiceCategory, service: service) {
//			return 30
//		} else {
//			return 0
//		}
//	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableViewCell") as! ServiceTableViewCell
		cell.delegate = self
		let service = services[indexPath.row]
		cell.service = service
		cell.business = business
		cell.serviceCategory = selectedServiceCategory
		cell.pet = selectedPet

		cell.nameLabel?.text = service.name
		cell.priceLabel.text = String(format: "R$ %.2f", service.price)
		cell.priceLabel.sizeToFit()

		
		if selectedService.id.isBlank {
			cell.checkBox.setOn(false, animated: false)
			cell.subServices = [SubService]()
			cell.reloadTable()
			return cell
		}


		cell.checkBox.setOn(selectedService.id == service.id, animated: false)
		cell.subServices = service.services
		cell.selectedSubServices = self.selectedSubServices
		cell.reloadTable()


		return cell

	}

//	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//		let service = serviceList.services[section]
//		guard let scheduleService = ScheduleManager.sharedInstance.getServiceFromSchedule(business: business, pet: selectedPet, serviceCategory: selectedServiceCategory, service: service) else {
//			return nil
//		}
//
//		let headerView = ServiceTableHeaderView.loadFromNibNamed("ServiceTableHeaderView") as? ServiceTableHeaderView
//		headerView?.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 18)
//
//		let dateFormatter = DateFormatter()
//		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//		let date = dateFormatter.date(from: "\(scheduleService.startDate) \(scheduleService.startTime)")
//
//		let dateString = dateFormatter.convertDateFormater(dateString: "\(scheduleService.startDate) \(scheduleService.startTime)", fromFormat: "yyyy-MM-dd HH:mm", toFormat: "dd 'de' MMMM")
//
//		let endDate = date?.addingTimeInterval(scheduleService.duration)
//
//		dateFormatter.dateFormat = "hh:mm"
//
//		let endDateString = dateFormatter.string(from: endDate!)
//
//		headerView?.timeLabel.text = "\(dateString), \(scheduleService.startTime) — \(endDateString)"
//
//		return headerView
//	}

//	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//
//		let service = serviceList.services[section]
//		guard let scheduleService = ScheduleManager.sharedInstance.getServiceFromSchedule(business: business, pet: selectedPet, serviceCategory: selectedServiceCategory, service: service) else {
//			let view = UIView()
//
//			view.backgroundColor = UIColor(hex: "EDEDED")
//
//			return view
//		}
//
//		let footerView = ServiceTableFooterView.loadFromNibNamed("ServiceTableFooterView") as? ServiceTableFooterView
//		footerView?.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 60)
//
//		footerView?.nameLabel.text = scheduleService.professionalName
//		if let url = URL(string: scheduleService.professionalPicture) {
//			footerView?.pictureImageView.pin_setImage(from: url)
//		}
//		var totalValue = scheduleService.price
//
//		for subService in scheduleService.services {
//			totalValue += subService.price
//		}
//		footerView?.totalValueLabel.text = String(format: "R$ %.2f", totalValue)
//
//
//		return footerView
//	}

}

extension SelectServiceTableViewCell : ServiceTableViewDelegate {
	
	
	func updateValue(service: Service) {
		
		guard let index = serviceList.services.index(of: service) else {
			return
		}
		
		
	}
	
	
	
	func didSelectedService(service: Service) {
		
		services = [service]
		
		selectedService = service
		
		if selectedService.services.count == 0 {
			delegate?.setSelectedService(selectedService: service, selectedSubServices: selectedSubServices)
		} else {
			continueButton.isHidden = false
			tableView.reloadData()
		}
		
		
	}
	
	func didUnselectedService(service:Service) {
		
		services = serviceList.services
		tableView.reloadData()

	}
	
	func didSelectedSubService(service:SubService) {
		if !selectedSubServices.contains(service){
			selectedSubServices.append(service)
		}
	}
	
	func didUnselectedSubService(service:SubService) {
		guard let index = selectedSubServices.index(of: service) else {
			return
		}
		selectedSubServices.remove(at: index)
	}
	
}

protocol SelectServiceTableViewCellDelegate: class {
	
	
	func setSelectedService(selectedService:Service, selectedSubServices:[SubService])
	
}

