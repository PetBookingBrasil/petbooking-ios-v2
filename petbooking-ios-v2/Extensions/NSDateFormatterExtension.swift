//
//  NSDateFormatterExtension.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 11/06/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

extension DateFormatter {
	
	func convertDateFormater(dateString:String, fromFormat: String, toFormat:String) -> String {
		
		self.dateFormat = fromFormat
		
		guard let date = self.date(from: dateString) else {
			assert(false, "no date from string")
			return ""
		}
		
		self.dateFormat = toFormat
		
		let newDateString = self.string(from: date)
		
		return newDateString
	}
	
}
