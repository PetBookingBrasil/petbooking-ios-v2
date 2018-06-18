//
//  UITextFieldExtension.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 08/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

extension UITextField {
	
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }

	func checkField() -> String? {
		guard let text = self.text, !text.isBlank else { return nil }
				
		return text
	}
}
