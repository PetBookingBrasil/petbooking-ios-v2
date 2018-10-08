//
//  AgendaCollectionViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 09/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class AgendaCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var weekLabel: UILabel!
	@IBOutlet weak var monthYearLabel: UILabel!
	@IBOutlet weak var goFowardButton: UIButton!
	@IBOutlet weak var goBackwardButton: UIButton!
	@IBOutlet weak var dayView: UIView!
	
	weak var delegate:AgendaCollectionViewCellDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()

        dayView.round()
    }
	
	@IBAction func goFoward(_ sender: Any) {
		delegate?.goFoward()
	}

	@IBAction func goBackward(_ sender: Any) {
		delegate?.goBackward()
	}
}

protocol AgendaCollectionViewCellDelegate: class {
	func goFoward()
	func goBackward()
}
