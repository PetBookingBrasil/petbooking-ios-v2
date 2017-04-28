//
//  UIViewControllerExtension.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 28/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
}
