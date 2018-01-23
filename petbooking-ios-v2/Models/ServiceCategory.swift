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

	@objc var id = ""
	@objc var name = ""
    @objc var serviceCount = 0
    @objc var slug = ""
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return ["id": "id",
                "name": "attributes.name",
                "serviceCount": "attributes.service_count",
                "slug": "attributes.slug"]
	}
}

class ServiceCategoryList: MTLModel, MTLJSONSerializing {
	
    @objc var categories = [ServiceCategory]()
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return ["categories": "data"]
	}
	
	@objc static func categoriesJSONTransformer() -> ValueTransformer {
		return MTLJSONAdapter.arrayTransformer(withModelClass: ServiceCategory.self)
	}
}
