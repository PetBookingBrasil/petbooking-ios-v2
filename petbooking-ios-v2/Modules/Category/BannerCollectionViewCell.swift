//
//  BannerCollectionViewCell.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 27/05/19.
//  Copyright © 2019 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bannerImageView.layer.cornerRadius = 6
        containerView.layer.cornerRadius = 6
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.5, height: 4.0) //Here your control your spread
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowRadius = 5.0 //Here your control your blur
    }

    func setCell(with banner: Banner) {
        bannerImageView.pin_setImage(from: try? banner.imageUrl.asURL())
    }

}
