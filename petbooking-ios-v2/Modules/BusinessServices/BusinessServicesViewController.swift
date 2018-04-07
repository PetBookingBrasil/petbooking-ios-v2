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
import ALLoadingView
import RealmSwift

enum ScheduleRow {
    case addPet, selectPet, selectCategory, selectService, selectProfessional, selectDate
}

class BusinessServicesViewController: ExpandableTableViewController, BusinessServicesViewProtocol {
	
	var presenter: BusinessServicesPresenterProtocol?
    var category: ServiceCategory?
	
	@IBOutlet weak var goToChartButton: UIButton!
	
    var selectedPet: Pet?
    var selectedServiceCategory: ServiceCategory?
    var selectedService: Service?
    var selectedSubServices = [SubService]()
    var selectedProfessional: Professional?
    
	var business: Business = Business()
	var petList: PetList?
	var serviceCategoryList: ServiceCategoryList = ServiceCategoryList()
	var serviceList: ServiceList = ServiceList()
	var professionalList: ProfessionalList! = ProfessionalList()
	var currentIndexPath: ExpandableIndexPath = ExpandableIndexPath(forSection: 0, forRow: 0, forSubRow: 0)
    
    var anotherPet = false
    
    // Row
    var rowList: [ScheduleRow] = [.selectPet, .selectCategory, .selectService, .selectProfessional, .selectDate]
	
	// Delegates
	weak var selectPetDelegate: BusinessServicesViewControllerDelegate?

    // MARK: APP Lifecycle
    override func viewDidLoad() {
		super.viewDidLoad()
		
		setBackButton()
        goToChartButton.round()

		ScheduleManager.sharedInstance.cleanSchedule()
		ScheduleManager.sharedInstance.createNewSchedule(business: business)
				
        setupExpandableTableView()
		
		ALLoadingView.manager.showLoadingView(ofType: .basic, windowMode: .fullscreen)
		presenter?.getPets()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
		checkServices()
	}
    
    fileprivate func setupExpandableTableView() {
        expandableTableView.expandableDelegate = self
        
        expandableTableView.register(UINib(nibName: "AddPetInformationTableViewCell", bundle: nil), forCellReuseIdentifier: "AddPetInformationTableViewCell")
        expandableTableView.register(UINib(nibName: "ServiceRowTableViewCell", bundle: nil), forCellReuseIdentifier:                  "ServiceRowTableViewCell")
        expandableTableView.register(UINib(nibName: "SelectPetTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectPetTableViewCell")
        expandableTableView.register(UINib(nibName: "SelectCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectCategoryTableViewCell")
        expandableTableView.register(UINib(nibName: "SelectServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectServiceTableViewCell")
        expandableTableView.register(UINib(nibName: "SelectProfessionalTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectProfessionalTableViewCell")
        expandableTableView.register(UINib(nibName: "SelectDateTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectDateTableViewCell")
    }
	
	deinit {
		ScheduleManager.sharedInstance.cleanSchedule()
	}
	
	func loadPets(petList: PetList) {
		self.petList = petList
 
        if petList.pets.count == 0 {
            rowList.insert(.addPet, at: 0)
        } else {
            if self.selectedPet == nil {
                guard let pet = petList.pets.first else { return }
                
                selectedPet = pet
            }

            if petList.pets.count > 1 || anotherPet {
                showContent(indexPath: IndexPath(row: 0, section: 0))
            }
            
            selectPetDelegate?.loadPets(petList: petList)
        }

        presenter?.getCategories(business: business)
        
        anotherPet = false
        expandableTableView.reloadData()
	}
	
	func loadCategories(serviceCategoryList: ServiceCategoryList) {
		ALLoadingView.manager.hideLoadingView()
		
		self.serviceCategoryList = serviceCategoryList
        
        if let category = self.category {
            self.selectedServiceCategory = category
            if let petlist = self.petList, petlist.pets.count <= 1 {
                findCategory()
                setSelectedCategory(selectedServiceCategory: self.selectedServiceCategory!)
            }
        }
		
		expandableTableView.reloadData()
	}
    
	func loadServices(serviceList: ServiceList) {
		ALLoadingView.manager.hideLoadingView()
		self.serviceList = serviceList
        
        if let categoryIndex = rowList.index(of: .selectService) {
            showContent(indexPath: IndexPath(row: categoryIndex, section: 0))
        }
		expandableTableView.reloadData()
	}
	
	@IBAction func goToCart(_ sender: Any) {
        guard let selectedCategory = selectedServiceCategory, let service = selectedService else { return }
        
        ScheduleManager.sharedInstance.addServiceToSchedule(business: business, pet: selectedPet!, serviceCategory: selectedCategory, service: service)
		
		for subService in selectedSubServices {
            ScheduleManager.sharedInstance.addSubServiceToSchedule(business: business, pet: selectedPet!, serviceCategory: selectedCategory, service: service, subService: subService)
		}
		
		checkServices()
		
		let alertVC = ScheduleToTheCartAlertViewController()
		alertVC.delegate = self
		alertVC.modalPresentationStyle = .overCurrentContext
		alertVC.modalTransitionStyle = .crossDissolve
		self.present(alertVC, animated: true, completion: nil)
	}
	
	func checkServices() {
		let nc = NotificationCenter.default
		nc.post(name:Notification.Name(rawValue:"cartUpdateNotification"),
		        object: nil,
		        userInfo:nil)
	}
    
	func clearSchedule() {
		selectedService = Service()
		selectedServiceCategory = ServiceCategory()
		selectedProfessional = Professional()
		selectedSubServices = [SubService]()
		self.showContent(indexPath: IndexPath(row: 4, section: 0))
		self.expandableTableView.reloadData()
		self.showContent(indexPath: IndexPath(row: 1, section: 0))
		goToChartButton.isHidden = true
	}
}

extension BusinessServicesViewController: ScheduleToTheCartAlertDelegate {
    func goToCart() {
        let cart = CartRouter.createModule(business:business)
        
        self.navigationController?.pushViewController(cart, animated: true)
        
        clearSchedule()
    }
    
    func scheduleMore() {
        selectedProfessional = nil
        selectedService = nil
        selectedSubServices = []
        serviceList = ServiceList()
        self.expandableTableView.reloadData()
        
        if let serviceIndex = rowList.index(of: .selectCategory) {
            showContent(indexPath: IndexPath(row: serviceIndex, section: 0))
        }
        
        goToChartButton.isHidden = true
    }

    func scheduleAnotherPet() {
        
        selectedPet = nil
        selectedServiceCategory = nil
        selectedService = nil
        selectedSubServices = []
        selectedProfessional = nil

        serviceCategoryList = ServiceCategoryList()
        serviceList = ServiceList()
        professionalList = ProfessionalList()
        
               self.showContent(indexPath: IndexPath(row: 4, section: 0))

        self.expandableTableView.reloadData()
        loadPets(petList: petList!)
//        self.expandableTableView.reloadData()
//
//        self.showContent(indexPath: IndexPath(row: 4, section: 0))
//        self.expandableTableView.reloadData()
//        self.showContent(indexPath: IndexPath(row: 0, section: 0))
//
//        selectPetDelegate?.loadPets(petList: petList!)
//        presenter?.getCategories(business: business)
//
//        expandableTableView.reloadData()

        goToChartButton.isHidden = true
    }
}

// Rows
extension BusinessServicesViewController: ExpandableTableViewDelegate, ServiceRowTableViewCellDelegate, SelectPetTableViewCellDelegate, SelectCategoryTableViewCellDelegate, SelectServiceTableViewCellDelegate, SelectProfessionalTableViewCellDelegate, SelectDateTableViewCellDelegate {
	
    // MARK: Row
	func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return rowList.count
	}
    
	func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell {
		
        if rowList[expandableIndexPath.row] == .addPet {
            let cell = expandableTableView.dequeueReusableCellWithIdentifier("AddPetInformationTableViewCell", forIndexPath: expandableIndexPath) as!AddPetInformationTableViewCell
            
            return cell
        }
        
		let cell = expandableTableView.dequeueReusableCellWithIdentifier("ServiceRowTableViewCell", forIndexPath: expandableIndexPath) as!ServiceRowTableViewCell
		cell.delegate = self
		cell.indexPath = IndexPath(row: expandableIndexPath.row, section: expandableIndexPath.section)
		
		switch rowList[expandableIndexPath.row] {
        case .selectPet:
            guard self.petList != nil else {
                cell.contentView.isHidden = true
                break
            }
            
            cell.contentView.isHidden = false
            
            cell.iconImageView.image = UIImage(named:"avatar-padrao-cachorro")
            
            if let selectedPet = selectedPet {
                cell.panelView.backgroundColor = .white

                if selectedPet.type != "dog" {
                    cell.iconImageView.image = UIImage(named:"avatar-padrao-gato")
                }
                
                if let url = URL(string: selectedPet.photoThumbUrl) {
                    cell.iconImageView.pin_setImage(from: url)
                }
                
                cell.titleLabel.text = selectedPet.name
                cell.titleLabel.textColor = .black
            } else {
                cell.panelView.backgroundColor = .red
                cell.titleLabel.text = "Adicionar Pet"
                cell.titleLabel.textColor = .white
            }
			
		case .selectCategory:
            if let selectedCategory = selectedServiceCategory {
                cell.contentView.isHidden = false
                cell.titleLabel.text = selectedCategory.name
                cell.iconImageView.image = UIImage(named: "\(selectedCategory.slug)-mini")
            } else {
                cell.contentView.isHidden = true
            }
			
		case .selectService:
            if let selectedService = selectedService {
                cell.contentView.isHidden = false
                cell.titleLabel.text = selectedService.name
                cell.iconImageView.image = UIImage(named:"checkedIcon")
            } else {
                cell.contentView.isHidden = true
            }

        case .selectProfessional:
            if let selectedProfessional = selectedProfessional {
                cell.contentView.isHidden = false
                cell.titleLabel.text = selectedProfessional.name
                cell.iconImageView.image = UIImage(named:"avatar-padrao-m")
                if let url = URL(string: selectedProfessional.photoThumbUrl) {
                    cell.iconImageView.pin_setImage(from: url)
                }
            } else {
                cell.contentView.isHidden = true
            }

        case .selectDate:
			cell.contentView.isHidden = true

		default:
			break
		}
		
		return cell
	}
	
	func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
        switch rowList[expandableIndexPath.row] {
        case .selectPet:
            if self.petList == nil {
                return 0
            } else {
                return 60
            }
            
        case .selectCategory:
            if selectedServiceCategory == nil {
                return 0
            } else {
                return 60
            }
            
        case .selectService:
            if selectedService == nil {
                return 0
            } else {
                return 60
            }
            
        case .selectProfessional:
            if selectedProfessional == nil {
                return 0
            } else {
                return 60
            }
            
        case .selectDate:
            return 0
            
        default:
            return 60
        }
	}
    
	func expandableTableView(_ expandableTableView: ExpandableTableView, estimatedHeightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
		return 50
	}
    
	func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) {

        if rowList[expandableIndexPath.row] == .selectPet, self.petList?.pets.count == 0 {
           print("DVD - didSelectRowAtExpandableIndexPath")
        }
    }
	
	func showContent(indexPath: IndexPath) {
		if indexPath.row != currentIndexPath.row {
            unexpandAllCells()
            tableView(expandableTableView, didSelectRowAt: indexPath)
		} else {
			tableView(expandableTableView, didSelectRowAt: indexPath)
			let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
			tableView(expandableTableView, didSelectRowAt: nextIndexPath)
		}
	}
	
	func setSelectedPet(selectedPet: Pet) {
		self.selectedPet = selectedPet
        
        if self.category == nil {
            showContent(indexPath: IndexPath(row: 1, section: 0))
            expandableTableView.reloadData()
        } else {
            findCategory()
            setSelectedCategory(selectedServiceCategory: self.selectedServiceCategory!)
        }
	}
    
    func findCategory() {
        for category in self.serviceCategoryList.categories where category.name == self.category!.name {
            self.selectedServiceCategory = category
        }
    }
	
	func setSelectedCategory(selectedServiceCategory: ServiceCategory) {
		self.selectedServiceCategory = selectedServiceCategory
		self.expandableTableView.reloadData()
				
        self.presenter?.getServices(business: business, service: selectedServiceCategory, pet: selectedPet)
	}
	
	func setSelectedService(selectedService: Service, selectedSubServices:[SubService]) {
		self.selectedService = selectedService
		self.selectedSubServices = selectedSubServices
		
		PetbookingAPI.sharedInstance.getProfessionalsList(service: selectedService) { (professionalList, message) in
			
			self.professionalList = professionalList
			self.expandableTableView.reloadData()
			self.showContent(indexPath: IndexPath(row: 3, section: 0))
		}
	}
	
	func setSelectedProfessional(professional: Professional) {
		self.selectedProfessional = professional
		self.expandableTableView.reloadData()
		
		selectedService?.professionalId = professional.id
		selectedService?.professionalName = professional.name
		selectedService?.professionalPicture =  professional.photoThumbUrl
		
		self.showContent(indexPath: IndexPath(row: 4, section: 0))
		self.expandableTableView.scrollToRow(at: IndexPath(row: 4, section: 0), at: .top, animated: true)
	}
	
	func setSelectedTime(service: Service) {
		selectedService = service
        goToChartButton.isHidden = false
	}

    // MARK: SubRow
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfSubRowsInRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> Int {
        
        switch rowList[expandableIndexPath.row] {
        case .addPet:
            return 0
            
        case .selectPet:
            if let petlist = self.petList, petlist.pets.count == 0 {
                return 0
            }
            
            return 1

        default:
            return 1
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, subCellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell {
        
        currentIndexPath = expandableIndexPath
        
        switch rowList[expandableIndexPath.row] {
        case .selectPet:
            let cell = expandableTableView.dequeueReusableCellWithIdentifier("SelectPetTableViewCell", forIndexPath: expandableIndexPath) as!SelectPetTableViewCell
            cell.delegate = self
            cell.petList = self.petList!
            cell.selectedPet = self.selectedPet!
            cell.collectionView.reloadData()
            selectPetDelegate = cell
            
            return cell
            
        case .selectCategory:
            let cell = expandableTableView.dequeueReusableCellWithIdentifier("SelectCategoryTableViewCell", forIndexPath: expandableIndexPath) as!SelectCategoryTableViewCell
            cell.delegate = self
            cell.serviceCategoryList = serviceCategoryList
            cell.selectedServiceCategory = selectedServiceCategory
            cell.collectionView.reloadData()
            
            return cell

        case .selectService:
            let cell = expandableTableView.dequeueReusableCellWithIdentifier("SelectServiceTableViewCell", forIndexPath: expandableIndexPath) as!SelectServiceTableViewCell
            
            if let selectedService = self.selectedService {
                cell.services = [selectedService]
            } else {
                cell.services = serviceList.services
            }
            
            cell.hasPet = self.petList!.pets.count > 0
            cell.serviceList = serviceList
            cell.selectedSubServices = self.selectedSubServices
            cell.selectedService = Service()
            cell.delegate = self
            cell.tableView.reloadData()
            
            return cell

        case .selectProfessional:
            let cell = expandableTableView.dequeueReusableCellWithIdentifier("SelectProfessionalTableViewCell", forIndexPath: expandableIndexPath) as!SelectProfessionalTableViewCell
            cell.professionalList = self.professionalList
            cell.delegate = self
            cell.collectionView.reloadData()
            
            return cell

        case .selectDate:
            let cell = expandableTableView.dequeueReusableCellWithIdentifier("SelectDateTableViewCell", forIndexPath: expandableIndexPath) as!SelectDateTableViewCell
            cell.selectedPet = selectedPet
            cell.selectedService = selectedService!
            cell.selectedProfessional = self.selectedProfessional!
            cell.reloadTimeColletion(professional: selectedProfessional!)
            cell.delegate = self
            
            return cell

        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
        
        switch rowList[expandableIndexPath.row] {
        case .selectPet:
            return 323
            
        case .selectCategory:
            let qty = serviceCategoryList.categories.count / 3 <= 1 ? 1 : serviceCategoryList.categories.count / 3
            let height = qty <= 3 ? qty * 120 : 360
            return CGFloat(height + 100)
            
        case .selectService:
            let qty = serviceList.services.count
            return CGFloat(90 + qty * 61)

        case .selectProfessional:
            return 265
            
        case .selectDate:
            return 460
            
        default:
            return 265
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, estimatedHeightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) { }
}

protocol BusinessServicesViewControllerDelegate: class {
	func loadPets(petList:PetList)
}

