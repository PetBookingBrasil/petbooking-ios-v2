//
//  BusinessImportedTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 23/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class BusinessImportedTableViewCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var distanceView: UIView!
	@IBOutlet weak var distanceLabel: UILabel!
	@IBOutlet weak var favoriteButton: UIButton!
	@IBOutlet weak var callButton: UIButton!
	
	var delegate: BusinessTableViewCellDelegate?
	var business:Business?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        callButton.round()
    }

	@IBAction func didTapCallButton(_ sender: Any) {
		guard let business = self.business else { return }
		
		let localCode = PhoneCodesConstants.getLocalCodeforCarrier()
		
		if let url = URL(string: "tel://0\(localCode!)\(business.phone)"), UIApplication.shared.canOpenURL(url) {
			if #available(iOS 10, *) {
				UIApplication.shared.open(url)
			} else {
				UIApplication.shared.openURL(url)
			}
            PetbookingAPI.sharedInstance.postPhoneNumberClick(from: business.name) { (success, message) in }
		}
	}
	
	@IBAction func didTapAddFavorite(_ sender: Any) {
		guard let business = self.business else { return }
		
		setFavorite(isFavorite: !business.isFavorited())
		
		delegate?.addToFavorites(business: business)
	}
	
	func setFavorite(isFavorite:Bool) {
		let imageName = isFavorite ? "heartFilledIcon" : "heartIconImported"
		favoriteButton.setBackgroundImage(UIImage(named:imageName), for: .normal)
	}
}
