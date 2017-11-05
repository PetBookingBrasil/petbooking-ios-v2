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
	
	class func openSansSemiBold(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: "OpenSans-Semibold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
	}
	
	class func exampleAvenirLight(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: "Avenir-Light", size: size) ?? UIFont.systemFont(ofSize: size)
	}
	
	class func robotoRegular(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: "Roboto-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
	}
	
	class func robotoLight(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: "Roboto-Light", size: size) ?? UIFont.boldSystemFont(ofSize: size)
	}
	
	class func robotoBold(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: "Roboto-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
	}
	
	class func robotoMedium(ofSize size: CGFloat) -> UIFont {
		return UIFont(name: "Roboto-Medium", size: size) ?? UIFont.boldSystemFont(ofSize: size)
	}
	
}
