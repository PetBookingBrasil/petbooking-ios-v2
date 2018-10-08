//
//  NotificationTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Enrique Melgarejo on 01/09/18.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    descriptionLabel.set(text: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sit ipsam quas dolorum culpa quibusdam molestiae omnis ea tenetur. Ea, doloribus.", lineHeight: 21.0)
  }

  func setup(withNotification notification: Any) {
    // TODO:
  }
}
