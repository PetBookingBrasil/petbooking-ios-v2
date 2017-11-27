//
//  SelectDateTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 31/10/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SelectDateTableViewCell: UITableViewCell {


	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var calendarMenuView: JTCalendarMenuView!
	@IBOutlet weak var calendar: JTHorizontalCalendarView!
	var calendarManager:JTCalendarManager!
	
	var dateFormatter = DateFormatter()
	var dateSelected = Date()
	
	var availableDates = [String]()
	var selectedProfessional:Professional = Professional()
	var selectedService:Service = Service()
	
	weak var delegate:SelectDateTableViewCellDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		numberLabel.round()
		numberLabel.setBorder(width: 1, color: UIColor(hex: "E4002B"))
		
		calendarManager = JTCalendarManager()
		calendarManager.settings.weekModeEnabled = true
		calendarManager.delegate = self
		
		calendarManager.menuView = calendarMenuView
		calendarManager.contentView = calendar
		calendarManager.setDate(Date())
		
		dateFormatter.dateFormat = "yyyy-MM-dd"
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.emptyDataSetSource = self
		tableView.emptyDataSetDelegate = self
		tableView.register(UINib(nibName: "TimeTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeTableViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func reloadTimeColletion(professional:Professional) {
		
		let dateKey = dateFormatter.string(from: dateSelected)
		
		selectedService.startDate = dateKey
		calendarManager.setDate(dateSelected)
		guard let times = selectedProfessional.schedule[dateKey] else {
			availableDates = []
			tableView.reloadData()
			return
		}
		availableDates = times
		tableView.reloadData()
		
		
	}
    
}

extension SelectDateTableViewCell:JTCalendarDelegate {
	
	func isProfessionalAvailable(date:Date) -> Bool {
		
		var isProfissionalAvailable = false
		let dateKey = dateFormatter.string(from: date)
		if let times = selectedProfessional.schedule[dateKey] {
			if times.count > 0 {
				isProfissionalAvailable = true
			}
		}
		
		return isProfissionalAvailable
	}
	
	func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
		
		// Today
		let dayView = dayView as! JTCalendarDayView
		let date = dayView.date
		let isProfissionalAvailable = self.isProfessionalAvailable(date: date!)
		
		if calendarManager.dateHelper.date(dateSelected, isTheSameDayThan: dayView.date) {
			dayView.circleView.isHidden = false
			dayView.circleView.backgroundColor = UIColor(hex: "E4002B")
			dayView.textLabel.textColor = UIColor.white
			dayView.textLabel.font = UIFont.robotoMedium(ofSize: 17)
		}	else{
			dayView.circleView.isHidden = true
			dayView.textLabel.textColor = isProfissionalAvailable ? UIColor(hex: "515151") : UIColor.lightGray
			dayView.textLabel.font = UIFont.robotoMedium(ofSize: 17)
		}
		
	}
	
	func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
		
		let dayView = dayView as! JTCalendarDayView
		
		if !self.isProfessionalAvailable(date: dayView.date!) {
			return
		}
		
		dateSelected = dayView.date
		
		reloadTimeColletion(professional: selectedProfessional)
		
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
		dateformattter.dateFormat = "MMMM, YYYY"
		
		label.font = UIFont.robotoMedium(ofSize: 14)
		label.textColor = UIColor(hex: "298FC2")
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

extension SelectDateTableViewCell: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return availableDates.count
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

		
		return 50
		
	}
	
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "TimeTableViewCell") as! TimeTableViewCell
		
		let date = availableDates[indexPath.row]
		
		cell.timeLabel.text = date
		
		
		return cell
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let time = availableDates[indexPath.row]
		selectedService.startTime = time
		
		delegate?.setSelectedTime(service: selectedService)
	}
	
}

extension SelectDateTableViewCell: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
	
	func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		
		
		let attributedString = NSAttributedString(string: "Nenhum horário disponível", attributes: [NSFontAttributeName : UIFont.robotoMedium(ofSize: 14), NSForegroundColorAttributeName : UIColor(hex: "515151")])
		
		return attributedString
	}
	

	
}

protocol SelectDateTableViewCellDelegate: class {
	
	
	func setSelectedTime(service:Service)
	
}
