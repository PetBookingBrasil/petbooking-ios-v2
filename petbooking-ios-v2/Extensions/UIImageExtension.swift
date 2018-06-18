//
//  UIImageExtension.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 04/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	
	func toBase64String(compressionQuality:CGFloat = 0.9) -> String? {
		
		let jpegCompressionQuality: CGFloat = compressionQuality
		if let base64String = UIImageJPEGRepresentation(self, jpegCompressionQuality)?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue:0)) {
			return base64String
		}
		
		return nil
	}
    
}
