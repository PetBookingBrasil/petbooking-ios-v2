//
//  UITextFieldExtension.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 08/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation
import UIKit


extension UITextField {
	
	func checkField() -> String?{
		
		guard let text = self.text else {
			return nil
		}
		
		if text.isBlank {
			return nil
		}
		
		return text
	}
	
	@IBInspectable var placeHolderColor: UIColor? {
		get {
			return self.placeHolderColor
		}
		set {
			self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
		}
	}
	
}
