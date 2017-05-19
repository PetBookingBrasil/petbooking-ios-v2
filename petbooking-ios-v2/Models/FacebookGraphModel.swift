//
//  FacebookGraphModel.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 01/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class FacebookGraphModel: MTLModel, MTLJSONSerializing {

		dynamic var name:String = ""
		dynamic var email:String = ""
		dynamic var profileUrl:String = ""

		
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"name": "name",
			"email": "email",
			"profileUrl": "picture.data.url"
		]
	}
	

	
}
