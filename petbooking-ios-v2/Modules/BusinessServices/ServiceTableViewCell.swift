//
//  ServiceTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 26/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import BEMCheckBox

class ServiceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: ServiceTableViewDelegate?
    
    var service: Service! = Service()
    var subServices = [SubService]()
    var selectedSubServices = [SubService]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkBox.boxType = .circle
        checkBox.onFillColor = UIColor(hex: "00CD6B")
        checkBox.onTintColor = UIColor(hex: "00CD6B")
        checkBox.onCheckColor = UIColor.white
        
        checkBox.offFillColor = UIColor(hex: "EDEDED")
        checkBox.tintColor = UIColor(hex: "858585")
        
        checkBox.delegate = self
        
        tableView.register(UINib(nibName: "AdditionalServiceTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionalServiceTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ServiceTableViewCell.didTapServiceNameLabel(_:)))
        nameLabel.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 10, 0))
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    @IBAction func didTapServiceNameLabel(_ sender: Any) {
        if !checkBox.on {
            self.delegate?.didSelectedService(service: self.service)
        }
    }
}

extension ServiceTableViewCell : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subServices.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalServiceTableViewCell") as! AdditionalServiceTableViewCell
        
        cell.delegate = self
        let subService = subServices[indexPath.row]
        
        cell.checkBox.setOn(selectedSubServices.contains(subService), animated: false)
        cell.service = subService
        cell.nameLabel.text = subService.name
        cell.priceLabel.text = String(format: "R$ %.2f", subService.price)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "   SERVIÇOS ADICIONAIS"
        label.font = UIFont.robotoMedium(ofSize: 9)
        label.textColor = UIColor(hex:"858585")
        
        return label
    }
}

extension ServiceTableViewCell:AdditionalServiceTableViewDelegate {
    func didSelectedService(subService: SubService) {
        delegate?.didSelectedSubService(service: subService)
    }
    
    func didUnselectedService(subService: SubService) {
        delegate?.didUnselectedSubService(service: subService)
    }
}

extension ServiceTableViewCell : BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox.on {
            self.delegate?.didSelectedService(service: self.service)
        } else {
            self.delegate?.didUnselectedService(service: self.service)
        }
    }
}

protocol ServiceTableViewDelegate: class {
    func didSelectedService(service:Service)
    func didUnselectedService(service:Service)
    func didSelectedSubService(service:SubService)
    func didUnselectedSubService(service:SubService)
    func updateValue(service:Service)
}
