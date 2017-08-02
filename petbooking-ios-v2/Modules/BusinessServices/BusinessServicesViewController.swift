//
//  BusinessServicesViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 24/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import BEMCheckBox

class BusinessServicesViewController: UIViewController, BusinessServicesViewProtocol {
	
	var presenter: BusinessServicesPresenterProtocol?
	
	@IBOutlet weak var servicesCollectionView: UICollectionView!
	@IBOutlet weak var petCollectionView: UICollectionView!
	@IBOutlet weak var servicesTableView: UITableView!
	
	var business:Business = Business()
	var petList:PetList = PetList()
	var serviceCategoryList:ServiceCategoryList = ServiceCategoryList()
	var serviceList:ServiceList = ServiceList()
	var selectedPet:Pet = Pet()
	var selectedServiceCategory:ServiceCategory = ServiceCategory()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		petCollectionView.register(UINib(nibName: "PetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PetCollectionViewCell")
		
		let cellSize = CGSize(width:100 , height:66)
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = cellSize
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 5
		layout.minimumInteritemSpacing = 0
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		petCollectionView.collectionViewLayout = layout
		
		servicesCollectionView.register(UINib(nibName: "ServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ServiceCollectionViewCell")
		
		let cellSize2 = CGSize(width:100 , height:120)
		let layout2 = UICollectionViewFlowLayout()
		layout2.itemSize = cellSize2
		layout2.scrollDirection = .horizontal
		layout2.minimumLineSpacing = 5
		layout2.minimumInteritemSpacing = 0
		layout2.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		servicesCollectionView.collectionViewLayout = layout2
		
		servicesTableView.register(UINib(nibName: "ServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "ServiceTableViewCell")
		servicesTableView.estimatedRowHeight = 300
		
		presenter?.getPets()
		
		
		ScheduleManager.sharedInstance.createNewSchedule(business: business)
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		servicesCollectionView.reloadData()
		petCollectionView.reloadData()
		servicesTableView.reloadData()
		
	}
	
	deinit {
		ScheduleManager.sharedInstance.cleanSchedule()
	}
	
	func loadPets(petList: PetList) {
		
		self.petList = petList
		
		self.petCollectionView.reloadData()
		
		if self.selectedPet.id.isBlank {
			
			guard let pet = self.petList.pets.first else {
				return
			}
			selectedPet = pet
			presenter?.getCategories(business: business)
			self.petCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
		}
		
	}
	
	func loadCategories(serviceCategoryList: ServiceCategoryList) {
		
		self.serviceCategoryList = serviceCategoryList
		
		self.servicesCollectionView.reloadData()
		
		if selectedServiceCategory.id.isBlank{
			
			guard let service = self.serviceCategoryList.categories.first else {
				return
			}
			selectedServiceCategory = service
			
			presenter?.getServices(business: business, service: selectedServiceCategory, pet: selectedPet)
			
			self.servicesCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
		}
	}
	
	func loadServices(serviceList: ServiceList) {
		
		self.serviceList = serviceList
		
		servicesTableView.reloadData()
		
	}
	
	
	
}

extension BusinessServicesViewController: UICollectionViewDataSource, UICollectionViewDelegate{
	
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		switch collectionView {
		case petCollectionView:
			return petList.pets.count
		case servicesCollectionView:
			return serviceCategoryList.categories.count
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
		
		if collectionView == petCollectionView {
			return getPetCell(indexPath: indexPath)
		} else {
			return getServiceCategoryCell(indexPath: indexPath)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		switch collectionView {
		case petCollectionView:
			selectedPet = petList.pets[indexPath.item]
			servicesTableView.reloadData()
			
			break
		case servicesCollectionView:
			
			let service = serviceCategoryList.categories[indexPath.item]
			selectedServiceCategory = service
						
			self.presenter?.getServices(business: business, service: service, pet: selectedPet)
			
			break
		default:
			break
		}
		
	}
	
	func getPetCell(indexPath: IndexPath) -> PetCollectionViewCell {
		
		let cell = petCollectionView.dequeueReusableCell(withReuseIdentifier: "PetCollectionViewCell", for: indexPath) as! PetCollectionViewCell
		
		let pet = petList.pets[indexPath.item]
		
		cell.isSelected = pet == selectedPet
		if pet == selectedPet {
			petCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
		}
		
		cell.nameLabel.text = pet.name
		
		if let url = URL(string: pet.photoThumbUrl) {
			cell.pictureImageView.pin_setImage(from: url)
		}
		
		return cell
		
	}
	
	func getServiceCategoryCell(indexPath: IndexPath) -> ServiceCollectionViewCell {
		
		let cell = servicesCollectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
		
		let service = serviceCategoryList.categories[indexPath.item]
		
		cell.isSelected = service == selectedServiceCategory
		if service == selectedServiceCategory {
			servicesCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
		}
		
		cell.nameLabel.text = service.name
		cell.pictureImageView.image = UIImage(named: service.slug)
		
		return cell
		
	}
	
}

extension BusinessServicesViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return serviceList.services.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return 1
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		return 78
		
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 10
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceTableViewCell") as! ServiceTableViewCell
		cell.delegate = self
		let service = serviceList.services[indexPath.section]
		cell.service = service
		
		cell.nameLabel?.text = service.name
		cell.priceLabel.text = String(format: "R$ %.2f", service.price)
		cell.priceLabel.sizeToFit()
		
		if ScheduleManager.sharedInstance.hasServiceFromSchedule(business: business, pet: selectedPet, serviceCategory: selectedServiceCategory, service: service) {
			cell.checkBox.setOn(true, animated: false)
		} else {
			cell.checkBox.setOn(false, animated: false)
		}
		
		
		return cell
		
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let view = UIView()
		
		view.backgroundColor = UIColor.lightGray
		
		return view
	}
	
}

extension BusinessServicesViewController : ServiceTableViewDelegate {
	
	
	func didSelectedService(service: Service) {
		
		
		let	calendar = ScheduleCalendarRouter.createModule(business: self.business, service: service, serviceCategory: selectedServiceCategory, pet: selectedPet)
		
		self.navigationController?.pushViewController(calendar, animated: true)
	}
	
	func didUnselectedService(service:Service) {
		
		ScheduleManager.sharedInstance.removeServiceFromSchedule(business: business, pet: selectedPet, serviceCategory: selectedServiceCategory, service: service)
		
	}
	
}
