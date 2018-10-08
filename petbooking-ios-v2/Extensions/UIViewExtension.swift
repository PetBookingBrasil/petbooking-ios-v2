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
	
	class func loadFromNibNamed(_ nibNamed: String, bundle: Bundle? = nil) -> UIView? {
		return UINib(nibName: nibNamed,bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
	}
	
	func round() {
		layer.cornerRadius = self.frame.height / 2
		layer.masksToBounds = true
	}
	
	func setBorder(width: CGFloat, color: UIColor) {
		layer.borderWidth = width
		layer.borderColor = color.cgColor
	}
	
	func dropShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.frame.height / 2).cgPath

        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 2

        self.layer.shouldRasterize = true
        self.layer.masksToBounds = false

		self.layer.rasterizationScale = UIScreen.main.scale
        
        self.clipsToBounds = true
	}
	
	func removeShadow() {
		self.layer.shadowColor = UIColor.clear.cgColor
		self.layer.shadowOpacity = 0.0
        
        self.clipsToBounds = true
	}
}
