//
//  Favorite.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 10/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class Favorite: MTLModel, MTLJSONSerializing {

	@objc dynamic var favoriteId = 0
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return ["favoriteId": "data.attributes.favorable_id"]
	}
	
}
