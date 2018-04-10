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
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	func setTitle(title:String) {
		let label = UILabel(frame: CGRect(x: 10.0, y: 0.0, width: 50.0, height: 40.0))
		label.backgroundColor = UIColor.clear
		label.font = UIFont.robotoMedium(ofSize: 16)
		
		label.numberOfLines = 2
		label.text = title
		label.textColor = .white
		label.sizeToFit()
		label.textAlignment = NSTextAlignment.center
		
		self.navigationItem.titleView = label
	}
	
	func setBackButton() {
		let backButton = UIBarButtonItem()
		backButton.target = self
		backButton.action = #selector(cancelButtonPressed)
		
		self.navigationItem.leftBarButtonItem = backButton
		self.navigationItem.leftBarButtonItem?.image = UIImage(named: "back_icon")
	}
		
	@objc func cancelButtonPressed(_ sender: AnyObject) {
		
		if let _ =  self.navigationController?.popViewController(animated: true) {
			
		}
	}
	
}
