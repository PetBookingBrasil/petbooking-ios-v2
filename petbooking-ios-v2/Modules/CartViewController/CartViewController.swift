//
//  CartViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 03/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import SideMenu

class CartViewController: UIViewController, CartViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var scheduleButton: UIButton!
    
    var presenter: CartPresenterProtocol?
    
    var business: Business = Business()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.target = self
        backButton.action = #selector(returnView)
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "back_icon")
        
        scheduleButton.round()
        
        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 2000
        
        title = "Carrinho de Agendamentos"
    }
    
    @objc func returnView() {
        presenter?.didTapReturnButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        calculateTotal()
    }
    
    @IBAction func schedule(_ sender: Any) {
        guard let services = ScheduleManager.sharedInstance.getServicesByBusiness(business: self.business) else { return }
        
        var itens = [Dictionary<String, Any>]()
        for service in services {
            
            var subServiceIds = [String]()
            for subService in service.services {
                subServiceIds.append(subService.subServiceId)
            }
            
            let item: [String : Any] = ["start_date": service.startDate,
                                        "start_time": service.startTime,
                                        "business_id": service.businessId,
                                        "service_id": service.serviceId,
                                        "professional_id": service.professionalId,
                                        "pet_id": service.petId,
                                        "additional_service_ids": subServiceIds,
                                        "with_transportation": false,
                                        "notes": ""]
            
            itens.append(item)
        }
        
        PetbookingAPI.sharedInstance.createShoppingCart(itens: itens) { (cart, message) in
            guard let cart = cart else { return }
            
            let cartVC = CartWebRouter.createModule(cart: cart)
            
            self.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
    
    func calculateTotal() {
        guard let services = ScheduleManager.sharedInstance.getServicesByBusiness(business: self.business) else { return }
        
        if services.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        
        var total = 0.0
        for service in services {
            
            total += service.price
            
            for subService in service.services {
                total += subService.price
            }
        }
        
        totalPriceLabel.text = String(format: "R$ %.2f", total)
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let schedule = ScheduleManager.sharedInstance.getSchedule(business: business)
        
        return schedule.petsSchedule.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let schedule = ScheduleManager.sharedInstance.getSchedule(business: business)
        let schedulePet = schedule.petsSchedule[section]
        
        guard let scheduleServices = ScheduleManager.sharedInstance.getServicesByPet(schedulePet: schedulePet) else { return 0 }
        
        return scheduleServices.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell
        cell.delegate = self
        let schedule = ScheduleManager.sharedInstance.getSchedule(business: business)
        
        let schedulePet = schedule.petsSchedule[indexPath.section]
        
        guard let scheduleServices = ScheduleManager.sharedInstance.getServicesByPet(schedulePet: schedulePet) else { return cell }
        
        let service = scheduleServices[indexPath.row]
        
        cell.service = service
        cell.subServices = service.services
        cell.tableViewHeightConstraint.constant = CGFloat(service.services.count * 30 + 20)
        cell.reloadTable()
        
        cell.serviceNameLabel.text = service.name
        cell.professionalNameLabel.text = service.professionalName
        cell.priceLabel.text =  String(format: "R$ %.2f", service.price)
        
        if let url = URL(string: service.professionalPicture) {
            cell.professionalPictureImageView.pin_setImage(from: url)
        }
        
        var totalPrice = service.price
        
        for subservice in service.services {
            totalPrice += subservice.price
        }
        
        cell.totalPriceLabel.text =  String(format: "R$ %.2f", totalPrice)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: "\(service.startDate) \(service.startTime)")
        
        let dateString = dateFormatter.convertDateFormater(dateString: "\(service.startDate) \(service.startTime)", fromFormat: "yyyy-MM-dd HH:mm", toFormat: "dd 'de' MMMM")
        
        let endDate = date?.addingTimeInterval(service.duration)
        
        dateFormatter.dateFormat = "HH:mm"
        
        let endDateString = dateFormatter.string(from: endDate!)
        
        cell.dateLabel.text = "\(dateString), \(service.startTime) — \(endDateString)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ServiceTableHeaderView.loadFromNibNamed("CartTableHeaderView") as? CartTableHeaderView
        headerView?.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 66)
        
        let schedule = ScheduleManager.sharedInstance.getSchedule(business: business)
        
        let schedulePet = schedule.petsSchedule[section]
        
        headerView?.nameLabel.text = schedulePet.name
        headerView?.numberLabel.text = "#\(section + 1)"
        
        if schedulePet.type == "dog" {
            headerView?.pictureImageView.image = UIImage(named:"avatar-padrao-cachorro")
        } else {
            headerView?.pictureImageView.image = UIImage(named:"avatar-padrao-gato")
        }
        
        if let url = URL(string: schedulePet.photoThumbUrl) {
            headerView?.pictureImageView.pin_setImage(from: url)
        }
        
        return headerView
    }
    
    func update(service: ScheduleService) {
        tableView.reloadData()
        calculateTotal()
    }
}
