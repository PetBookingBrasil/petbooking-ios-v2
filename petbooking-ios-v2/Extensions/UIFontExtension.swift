//
//  UIFontExtension.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 19/06/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
	
	class func openSansRegular(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: "OpenSans-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
	}
	
	class func openSansBold(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: "OpenSans-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
	}
	
	class func exampleAvenirLight(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: "Avenir-Light", size: size) ?? UIFont.systemFont(ofSize: size)
	}
	
}
