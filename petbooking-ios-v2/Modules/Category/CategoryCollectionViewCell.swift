//
//  CategoryCollectionViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 11/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import PINRemoteImage

class CategoryCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var pictureImageView: UIImageView!
    
    func setImage(with category: ServiceCategory) {
        if category.mobileThumb.contains("http") {
            if let url = URL(string: category.mobileThumb) {
                pictureImageView.pin_setImage(from: url)
            }
        } else {
            if let url = URL(string: "https://cdn.petbooking.com.br\(category.slug)") {
                pictureImageView.pin_setImage(from: url)
            }
        }
    }
}
