//
//  ServiceCategory.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 26/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class ServiceCategory: MTLModel, MTLJSONSerializing {

	@objc dynamic var id = ""
	@objc dynamic var name = ""
	@objc dynamic var serviceCount = 0
	@objc dynamic var slug = ""
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "id",
			"name": "attributes.name",
			"serviceCount": "attributes.service_count",
			"slug": "attributes.slug"
		]
	}
}

class ServiceCategoryList: MTLModel, MTLJSONSerializing {
	
	@objc dynamic var categories = [ServiceCategory]()
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"categories": "data"
		]
	}
	
	static func categoriesJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: ServiceCategory.self)
		
	}
}
