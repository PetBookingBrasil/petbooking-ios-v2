//
//  ServiceCollectionViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 26/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class ServiceCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var pictureImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
	override var isSelected: Bool {
		didSet {
			if isSelected {
				pictureImageView.alpha = 1
				pictureImageView.dropShadow()
			} else {
				pictureImageView.alpha = 0.5
				pictureImageView.removeShadow()
			}
		}
	}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureImageView.image = UIImage()
    }
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pictureImageView.round()
    }
    
    func setupCell(with service: ServiceCategory) {
        
        nameLabel.text = service.name
        
        if let url = URL(string: service.templateIcon) {
            pictureImageView.pin_setImage(from: url)
        } else {
            if let url = URL(string: "https://cdn.petbooking.com.br\(service.slug)") {
                pictureImageView.pin_setImage(from: url)
            }
        }
    }
}
