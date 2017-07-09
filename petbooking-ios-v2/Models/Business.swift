//
//  Business.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 24/06/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle


class Business: MTLModel, MTLJSONSerializing {

	dynamic var id = ""
	dynamic var type = ""
	dynamic var name = ""
	dynamic var photoUrl = ""
	dynamic var photoThumbUrl = ""
	dynamic var neighborhood:String = ""
	dynamic var distance:Double = 0.0
	dynamic var street:String = ""
	dynamic var streetNumber:String = ""
	dynamic var rating:Double  = 0.0
	dynamic var ratingCount:Int  = 0
	dynamic var isFavorite = false
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "id",
			"type": "type",
			"name": "attributes.name",
			"neighborhood": "attributes.neighborhood",
			"street": "attributes.street",
			"streetNumber": "attributes.street_number",
			"distance": "attributes.distance",
			"rating": "attributes.rating_average",
			"ratingCount": "attributes.rating_count",
			"photoUrl": "attributes.cover_image.url",
			"photoThumbUrl": "attributes.cover_image.thumb.url",
			"isFavorite": "user_favorite"
		]
	}
	
	class func distanceJSONTransformer() -> ValueTransformer {
		let _forwardBlock: MTLValueTransformerBlock? = { (value, success, error) in
			
			guard let distance = value else {
				return 0.0
			}
			
			return distance
		}
		
		return MTLValueTransformer(usingForwardBlock: _forwardBlock)
	}
	
}

class BusinessList: MTLModel, MTLJSONSerializing {
	
	dynamic var businesses = [Business]()
	dynamic var page = 0
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"businesses": "data"
		]
	}
	
	static func businessesJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: Business.self)
		
	}
}
