//
//  AddPetInformationTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 08/03/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class AddPetInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var panelView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        panelView.dropShadow()
        panelView.layer.cornerRadius = 4
    }
}
