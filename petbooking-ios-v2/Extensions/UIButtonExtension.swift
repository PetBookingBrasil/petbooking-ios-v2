//
//  UIButtonExtension.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 03/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

extension UIButton {
	
	func setSubTextTitleFont(_ pSubString : String, font : UIFont, controlState: UIControlState){
		
		
		let title = self.title(for: controlState)!
		let fontColor = self.titleColor(for: controlState)!
		let currentFont = self.titleLabel?.font
		
		let currentAttString = NSAttributedString(string: title, attributes: [NSFontAttributeName:currentFont!, NSForegroundColorAttributeName:fontColor])
		
		let attributedString: NSMutableAttributedString = NSMutableAttributedString(attributedString: currentAttString);
		
		
		
		let range = attributedString.mutableString.range(of: pSubString, options: .literal)
		
		if range.location != NSNotFound {
			attributedString.addAttribute(NSFontAttributeName, value: font, range: range);
		}
		
		
		self.setAttributedTitle(attributedString, for: controlState)
		
	}
}
