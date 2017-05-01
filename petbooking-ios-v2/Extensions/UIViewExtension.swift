//
//  UIViewExtension.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 26/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	func round() {
		layer.cornerRadius = self.frame.height / 2
		layer.masksToBounds = true
	}
	
	
	func setBorder(width:CGFloat, color: UIColor) {
		layer.borderWidth = width
		layer.borderColor = color.cgColor
	}
	
}