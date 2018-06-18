//
//  Token.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 10/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class Token: Object {

	@objc dynamic var token  = ""
	@objc dynamic var type  = ""
	
	override static func primaryKey() -> String? {
		return "type"
	}
	
}
