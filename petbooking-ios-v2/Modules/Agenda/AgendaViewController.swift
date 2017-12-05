//
//  AgendaViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 08/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import DZNEmptyDataSet
import ALLoadingView

class AgendaViewController: UIViewController, AgendaViewProtocol {

	@IBOutlet weak var dateCollectionView: UICollectionView!
	@IBOutlet weak var petsCollectionView: UICollectionView!
	@IBOutlet weak var servicesTableView: UITableView!
	@IBOutlet weak var emptyView: UIView!
	
	var presenter: AgendaPresenterProtocol?
	
	var scheduledServiceList:ScheduledServiceList! = ScheduledServiceList()
	var scheduledPets:[ScheduledPet]! = [ScheduledPet]()
	var scheduledServices:[ScheduledService]! = [ScheduledService]()
	
	var dateFormatter = DateFormatter()
	
	var currentDate = Date()

	override func viewDidLoad() {
        super.viewDidLoad()
		
		setBackButton()
		
		title = "Agenda"
		
		dateCollectionView.register(UINib(nibName: "AgendaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AgendaCollectionViewCell")
		
		let cellSize = CGSize(width:Device.TheCurrentDeviceWidth , height:130)
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = cellSize
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		dateCollectionView.collectionViewLayout = layout
		
		petsCollectionView.register(UINib(nibName: "AgendaPetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AgendaPetCollectionViewCell")
		
		let cellSize2 = CGSize(width:100 , height:66)
		let layout2 = UICollectionViewFlowLayout()
		layout2.itemSize = cellSize2
		layout2.scrollDirection = .horizontal
		layout2.minimumLineSpacing = 5
		layout2.minimumInteritemSpacing = 0
		layout2.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		petsCollectionView.collectionViewLayout = layout2
		
		servicesTableView.register(UINib(nibName: "AgendaTableViewCell", bundle: nil), forCellReuseIdentifier: "AgendaTableViewCell")
		servicesTableView.estimatedRowHeight = 2000
		
		servicesTableView.emptyDataSetSource = self
		servicesTableView.emptyDataSetDelegate = self
		
		ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .fullscreen)
		getScheduledServices()
		
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.navigationBar.barTintColor = UIColor(hex: "E4002B")
	}
	
	func getScheduledServices() {
		
		PetbookingAPI.sharedInstance.getScheduleList(page: 1) { (scheduledServiceList, message) in
			
			ALLoadingView.manager.hideLoadingView(withDelay: 1) {
				
				
			}
			
			guard let scheduledServiceList = scheduledServiceList else {
				return
			}
			
			if scheduledServiceList.scheduledDates.count > 0 {
				self.emptyView.isHidden = true
			}
			
			self.scheduledServiceList = scheduledServiceList
			self.dateCollectionView.reloadData()
			
			var index = -1
			let today = Date()
			for scheduledDate in scheduledServiceList.scheduledDates {
				
				index += 1
				if NSCalendar.current.compare(scheduledDate.date, to: today, toGranularity: .day) != .orderedAscending {
					break
				}
				
			}
			if index >= 0 {
				self.dateCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: false)
			}
		}
		
	}

}

extension AgendaViewController: UICollectionViewDelegate, UICollectionViewDataSource, AgendaCollectionViewCellDelegate {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		switch collectionView {
		case petsCollectionView:
			return scheduledPets.count
		case dateCollectionView:
			return scheduledServiceList.scheduledDates.count
		default:
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		
		guard let dateCell = cell as? AgendaCollectionViewCell else {
			return
		}
		
		let scheduledDate = scheduledServiceList.scheduledDates[indexPath.item]
		
		let today = Date()
		currentDate = scheduledDate.date
		if NSCalendar.current.compare(scheduledDate.date, to: today, toGranularity: .day) == .orderedAscending {
			
			dateCell.contentView.backgroundColor = UIColor(hex: "9A9A9A")
			dateCell.dayView.setBorder(width: 2, color: .white)
			dateCell.dayView.backgroundColor = .clear
			dateCell.dayLabel.textColor = .white
			navigationController?.navigationBar.barTintColor = UIColor(hex: "9A9A9A")
			
		} else {
			dateCell.contentView.backgroundColor = UIColor(hex: "E4002B")
			dateCell.dayView.setBorder(width: 0, color: .white)
			dateCell.dayView.backgroundColor = .white
			dateCell.dayLabel.textColor = UIColor(hex: "E4002B")
			navigationController?.navigationBar.barTintColor = UIColor(hex: "E4002B")
		}
		
		scheduledPets = scheduledDate.scheduledPets
		petsCollectionView.reloadData()
		petsCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .right)
		scheduledServices = scheduledPets[0].services
		servicesTableView.reloadData()
		
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if collectionView == petsCollectionView {
			return getPetCell(indexPath: indexPath)
		} else {
			return getDateColectionViewCell(indexPath: indexPath)
		}
				
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		switch collectionView {
		case petsCollectionView:
			let pet = scheduledPets[indexPath.item]
			scheduledServices = pet.services
			servicesTableView.reloadData()
			break
		case dateCollectionView:
			break
		default:
			break
		}
		
	}
	
	func getDateColectionViewCell(indexPath: IndexPath) -> AgendaCollectionViewCell {

		let cell = dateCollectionView.dequeueReusableCell(withReuseIdentifier: "AgendaCollectionViewCell", for: indexPath) as! AgendaCollectionViewCell
		cell.delegate = self
		
		if indexPath.item == 0 {
			cell.goBackwardButton.isHidden = true
		} else {
			cell.goBackwardButton.isHidden = false
		}
		
		if indexPath.item == scheduledServiceList.scheduledDates.count - 1 {
			cell.goFowardButton.isHidden = true
		} else {
			cell.goFowardButton.isHidden = false
		}
		let scheduledDate = scheduledServiceList.scheduledDates[indexPath.item]
		
		
		
		dateFormatter.dateFormat = "dd"
		cell.dayLabel.text = dateFormatter.string(from: scheduledDate.date)
		dateFormatter.dateFormat = "EEEE"
		cell.weekLabel.text = dateFormatter.string(from: scheduledDate.date).capitalized
		
		dateFormatter.dateFormat = "MMMM, yyyy"
		cell.monthYearLabel.text = dateFormatter.string(from: scheduledDate.date).uppercased()
		
		return cell
	}
	
	func getPetCell(indexPath: IndexPath) -> AgendaPetCollectionViewCell {
		
		let cell = petsCollectionView.dequeueReusableCell(withReuseIdentifier: "AgendaPetCollectionViewCell", for: indexPath) as! AgendaPetCollectionViewCell
		
		let pet = scheduledPets[indexPath.item]
		
		cell.nameLabel.text = pet.name
		
		if pet.type == "dog" {
			cell.pictureImageView.image = UIImage(named:"avatar-padrao-cachorro")
		} else {
			cell.pictureImageView.image = UIImage(named:"avatar-padrao-gato")
		}
		if let url = URL(string: pet.photoThumbUrl) {
			cell.pictureImageView.pin_setImage(from: url)
		}
		
		return cell
		
	}
	
	func goFoward() {
		
		
		guard let currentIndexPath = dateCollectionView.indexPathsForVisibleItems.first else {
			return
		}
		
		let indexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
		
		dateCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
		
	}
	
	func goBackward() {
		
		guard let currentIndexPath = dateCollectionView.indexPathsForVisibleItems.first else {
			return
		}
		
		let indexPath = IndexPath(item: currentIndexPath.item - 1, section: currentIndexPath.section)
		
		dateCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
	}
}

extension AgendaViewController: UITableViewDelegate, UITableViewDataSource, AgendaTableViewCellDelegate, AlertCancelScheduledDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		
		return scheduledServices.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return 1
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		let service = scheduledServices[indexPath.section]
		
		let headerSize = scheduledServices.count > 0 ? 20 : 0
		
		return CGFloat(210 + headerSize + service.subServices.count * 30)
		
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "AgendaTableViewCell") as! AgendaTableViewCell
		cell.delegate = self
		
		let today = Date()
		if NSCalendar.current.compare(currentDate, to: today, toGranularity: .day) != .orderedDescending {
			
			cell.cancelButton.isHidden = true
			
		} else {
			cell.cancelButton.isHidden = false
		}
		
		let service = scheduledServices[indexPath.section]

		cell.scheduledService = service
		cell.subServices = service.subServices
		cell.reloadTable()
		
		cell.businessLabel.text = service.businessName
		cell.serviceNameLabel.text = service.serviceName
		cell.priceLabel.text = String(format: "R$ %.2f", service.price)
		cell.priceLabel.sizeToFit()
		cell.professionalNameLabel.text = service.professionalName
		cell.timeLabel.text = "\(service.startTime) - \(service.endTime)"
		
		if let url = URL(string: service.professionalPicture) {
			cell.professionalImageView.pin_setImage(from: url)
		}
		
		return cell
		
	}
	
	func showCancelScheduledServiceAlert(scheduledService: ScheduledService) {
		
		let alertVC = AlertCancelScheduledViewController()
		alertVC.delegate = self
		alertVC.scheduledService = scheduledService
		alertVC.modalPresentationStyle = .overCurrentContext
		alertVC.modalTransitionStyle = .crossDissolve
		self.present(alertVC, animated: true, completion: nil)
		

	}
	
	func cancelScheduledService(scheduledService: ScheduledService) {
		
				PetbookingAPI.sharedInstance.cancelScheduledService(scheduledService: scheduledService) { (item, message) in
		
					let alertVC = AlertPopupRouter.createModule(title: "Agendamento Cancelado!", message: "O seu agendamento foi cancelado com sucesso.")
					alertVC.modalPresentationStyle = .overCurrentContext
					alertVC.modalTransitionStyle = .crossDissolve
					self.present(alertVC, animated: true, completion: nil)
					
					self.getScheduledServices()
				}
		
	}
	
	
}

extension AgendaViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
	
	func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
		

		return UIImage()

	}
	
	func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
		
	
		let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		indicator.startAnimating()
		
		return indicator
	}
	
	
}