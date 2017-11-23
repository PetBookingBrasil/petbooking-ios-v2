//
//  Review.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 14/11/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class Review: MTLModel, MTLJSONSerializing {

	dynamic var id = ""
	dynamic var businessId = 0
	dynamic var businessRating:Double = 0.0
	dynamic var comment = ""
	dynamic var userId = 0
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "id",
			"businessId": "attributes.business_id",
			"businessRating": "attributes.business_rating",
			"comment": "attributes.comment",
			"userId": "attributes.user_id"
		]
	}
	
}

class ReviewList: MTLModel, MTLJSONSerializing {
	
	dynamic var reviews = [Review]()
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"reviews": "data"
		]
	}
	
	static func reviewsJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: Review.self)
		
	}
}
