//
//  Consumer.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 30/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle
import Realm
import RealmSwift

class Consumer: MTLModel, MTLJSONSerializing {
	
	dynamic var token:String = ""
	dynamic var tokenExpiresAt:Double = 0
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"token": "data.attributes.token",
			"tokenExpiresAt": "data.attributes.token_expires_at"
		]
	}
}

class ConsumerRealm: Object {
	
	dynamic var token:String = ""
	dynamic var tokenExpiresAt:Double = 0
	
	override static func primaryKey() -> String? {
		return "token"
	}
	
}
