//
//  ErrorRest.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 01/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class ErrorRest: MTLModel, MTLJSONSerializing {

	@objc dynamic var errorCode:Int = 0
	@objc dynamic var errorDetail:String = ""
	@objc dynamic var errorStatus:Int = 0
	@objc dynamic var errorTitle:String = ""
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"errorCode": "code",
			"errorDetail": "detail",
			"errorStatus": "status",
			"errorTitle": "title"
		]
	}
}
