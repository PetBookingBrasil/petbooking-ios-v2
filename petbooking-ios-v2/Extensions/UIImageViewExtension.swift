//
//  UIImageViewExtension.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 26/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
	
	func changeImageColor(color:UIColor) {
		
		guard let image = self.image else {
			return
		}
		
		self.image = image.withRenderingMode(.alwaysTemplate)
		self.tintColor = color
		
	}
	
}
