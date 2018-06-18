//
//  StringExtension.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 07/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

extension String {
	
	//To check text field or String is blank or not
	var isBlank: Bool {
		get {
			let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
			return trimmed.isEmpty
		}
	}
	
	//Validate Email
	var isEmail: Bool {
		do {
			let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
			return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
		} catch {
			return false
		}
	}
	
	var isAlphanumeric: Bool {
		return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
	}
	
	//validate Password
	var isValidPassword: Bool {
		do {
			let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
			if (regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil) {
				if (self.count >= 6 && self.count <= 20) {
					return true
				} else {
					return false
				}
			} else {
				return false
			}
		} catch {
			return false
		}
	}
	
	var localized:String {
		get {
			return NSLocalizedString(self, comment: "")
		}
	}
}
