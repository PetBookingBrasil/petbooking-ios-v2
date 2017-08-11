//
//  ScheduleCalendarViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 29/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import BEMCheckBox

class ScheduleCalendarViewController: UIViewController, ScheduleCalendarViewProtocol {
	
	@IBOutlet weak var subServicesLabel: UILabel!
	@IBOutlet weak var calendarContainer: UIView!
	
	@IBOutlet weak var continueScheduleButton: UIButton!
	@IBOutlet weak var petCheckBox: BEMCheckBox!
	@IBOutlet weak var checkBox: BEMCheckBox!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var petNameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var calendarMenuView: JTCalendarMenuView!
	@IBOutlet weak var calendar: JTHorizontalCalendarView!
	var calendarManager:JTCalendarManager!
	@IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var professionalCollectionView: UICollectionView!
	
	@IBOutlet weak var timeCollectionView: UICollectionView!
	
	
	var dateFormatter = DateFormatter()
	var dateSelected = Date()
	
	var business:Business = Business()
	var serviceCategory:ServiceCategory = ServiceCategory()
	var service:Service = Service()
	var pet:Pet = Pet()
	
	var professionalList:ProfessionalList! = ProfessionalList()
	var availableDates = [String]()
	var selectedProfessional:Professional?
	
	var subServices = [SubService]()

	var presenter: ScheduleCalendarPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
		
		
		continueScheduleButton.round()

		calendarManager = JTCalendarManager()
		calendarManager.settings.weekModeEnabled = true
		calendarManager.delegate = self
		
		calendarManager.menuView = calendarMenuView
		calendarManager.contentView = calendar
		calendarManager.setDate(Date())
		
		petCheckBox.boxType = .square
		checkBox.boxType = .square
		checkBox.setOn(true, animated: false)
		petCheckBox.setOn(true, animated: false)
		
		tableView.register(UINib(nibName: "AdditionalServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionalServiceTableViewCell")
		
		tableViewHeightConstraint.constant = CGFloat(service.services.count * 40)
		
		professionalCollectionView.register(UINib(nibName: "ProfessionalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfessionalCollectionViewCell")
		
		let cellSize = CGSize(width:148 , height:50)
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = cellSize
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		professionalCollectionView.collectionViewLayout = layout
		
		timeCollectionView.register(UINib(nibName: "TImeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TImeCollectionViewCell")
		
		let cellSize2 = CGSize(width:78 , height:40)
		let layout2 = UICollectionViewFlowLayout()
		layout2.itemSize = cellSize2
		layout2.scrollDirection = .horizontal
		layout2.minimumLineSpacing = 0
		layout2.minimumInteritemSpacing = 0
		layout2.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		timeCollectionView.collectionViewLayout = layout2
		
		title = business.name
		nameLabel.text = service.name
		priceLabel.text = String(format: "R$ %.2f", service.price)
		petNameLabel.text = pet.name
		
		dateFormatter.dateFormat = "yyyy-MM-dd"
		
		PetbookingAPI.sharedInstance.getProfessionalsList(service: self.service) { (professionalList, message) in
			
			self.professionalList = professionalList
			
			self.professionalCollectionView.reloadData()
			
		}

    }

	@IBAction func didTapContinueSchedule(_ sender: Any) {
		
		
		ScheduleManager.sharedInstance.addServiceToSchedule(business: business, pet: pet, serviceCategory: serviceCategory, service: service)
		
		for subService in subServices {
			ScheduleManager.sharedInstance.addSubServiceToSchedule(business: business, pet: pet, serviceCategory: serviceCategory, service: service, subService: subService)
		}
		
		self.navigationController?.popViewController(animated: true)
		
	}
	
	func validateFields() {
		
		if !service.professionalId.isBlank && !service.startDate.isBlank && !service.startTime.isBlank{
			continueScheduleButton.backgroundColor = UIColor(hex: "E4002B")
			continueScheduleButton.isEnabled = true
		} else {
			continueScheduleButton.backgroundColor = UIColor(hex: "D8D8D8")
			continueScheduleButton.isEnabled = false
		}
		
	}
	
	
}

extension ScheduleCalendarViewController:JTCalendarDelegate {
	
	func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
		
		// Today
		let dayView = dayView as! JTCalendarDayView
		
		if calendarManager.dateHelper.date(dateSelected, isTheSameDayThan: dayView.date) {
			dayView.circleView.isHidden = false
			dayView.circleView.backgroundColor = UIColor(hex: "E4002B")
			dayView.textLabel.textColor = UIColor.white
			dayView.textLabel.font = UIFont.openSansSemiBold(ofSize: 17)
		}	else{
			dayView.circleView.isHidden = true
			dayView.textLabel.textColor = UIColor.white
			dayView.textLabel.font = UIFont.openSansRegular(ofSize: 17)
		}
		
	}
	
	func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
		
		let dayView = dayView as! JTCalendarDayView
		
		dateSelected = dayView.date
		
		if let professional = selectedProfessional {
			reloadTimeColletion(professional: professional)
		}

		dayView.circleView.transform = dayView.transform.scaledBy(x: 0.1, y: 0.1)
		
		UIView.transition(with: dayView, duration: 0.3, options: UIViewAnimationOptions(rawValue: 0), animations: {
			dayView.circleView.transform = .identity
			self.calendarManager.reload()

		}, completion: nil)
		
	}
	
	func calendar(_ calendar: JTCalendarManager!, prepareMenuItemView menuItemView: UIView!, date: Date!) {
		
		guard let label = menuItemView as? UILabel else {
			return
		}
		
	 let dateformattter =	DateFormatter()
		dateformattter.dateFormat = "MMMM YYYY"
		
		label.font = UIFont.openSansSemiBold(ofSize: 14)
		label.textColor = .white
		label.text = dateformattter.string(from: date).uppercased()
		
		
	}
	
	func calendar(_ calendar: JTCalendarManager!, canDisplayPageWith date: Date!) -> Bool {
		
		return calendarManager.dateHelper.date(date, isEqualOrAfter: Date())
		
	}
	
	func calendarBuildWeekView(_ calendar: JTCalendarManager!) -> UIView! {
		
		let calendarWeekView = JTCalendarWeekView()
		calendarWeekView.manager = calendarManager
		
		calendarWeekView.setStart(Date(), updateAnotherMonth: false, monthDate: Date())
		
		return calendarWeekView
		
	}
	
}

extension ScheduleCalendarViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		
		return 1
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		subServicesLabel.isHidden = service.services.count == 0
		
		return service.services.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalServiceTableViewCell") as! AdditionalServiceTableViewCell
		cell.delegate = self
		let subService = service.services[indexPath.row]
		cell.service = subService
		
		cell.nameLabel.text = subService.name
		cell.priceLabel.text = String(format: "R$ %.2f", subService.price)
		
		return cell
		
	}
	
}

extension ScheduleCalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate{
	
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		switch collectionView {
		case professionalCollectionView:
			return professionalList.professionals.count
		case timeCollectionView:
			return availableDates.count
		default:
			return 0
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                    layout collectionViewLayout: UICollectionViewLayout,
	                    sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		return CGSize(width: 100, height: 66)
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                    layout collectionViewLayout: UICollectionViewLayout,
	                    minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1.0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout
		collectionViewLayout: UICollectionViewLayout,
	                    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1.0
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if collectionView == professionalCollectionView {
			return getPetCell(indexPath: indexPath)
		} else {
			return getServiceCategoryCell(indexPath: indexPath)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		switch collectionView {
		case timeCollectionView:
			
			let time = availableDates[indexPath.item]
			service.startTime = time
			
			break
		case professionalCollectionView:

			let professional = professionalList.professionals[indexPath.item]
			selectedProfessional = professional
			
			service.professionalId = professional.id
			service.professionalName = professional.name
			service.professionalPicture = professional.photoThumbUrl
			
			reloadTimeColletion(professional: professional)
			
			break
		default:
			break
		}
		validateFields()
	}
	
	func getPetCell(indexPath: IndexPath) -> ProfessionalCollectionViewCell {
		
		let cell = professionalCollectionView.dequeueReusableCell(withReuseIdentifier: "ProfessionalCollectionViewCell", for: indexPath) as! ProfessionalCollectionViewCell
		
		let professional = professionalList.professionals[indexPath.item]
		
		cell.nameLabel.text = professional.name
		
		if let url = URL(string: professional.photoThumbUrl) {
			cell.profileImageView.pin_setImage(from: url)
		}
		
		return cell
		
	}
	
	func getServiceCategoryCell(indexPath: IndexPath) -> TImeCollectionViewCell {
		
		let cell = timeCollectionView.dequeueReusableCell(withReuseIdentifier: "TImeCollectionViewCell", for: indexPath) as! TImeCollectionViewCell
		
		let date = availableDates[indexPath.item]
		
		cell.timeLabel.text = date
		
		return cell
		
	}
	
	func reloadTimeColletion(professional:Professional) {
		
		let dateKey = dateFormatter.string(from: dateSelected)
		
		service.startDate = dateKey
		
		guard let times = professional.schedule[dateKey] else {
			availableDates = []
			timeCollectionView.reloadData()
			return
		}
		availableDates = times
		timeCollectionView.reloadData()
		
	}
	
}

extension ScheduleCalendarViewController:AdditionalServiceTableViewDelegate {
	
	func didSelectedService(subService: SubService) {
		
		subServices.append(subService)

	}
	
	func didUnselectedService(subService: SubService) {
		
		guard let index = subServices.index(of: subService) else {
			return
		}
		
		subServices.remove(at: index)

		
	}
	
}

