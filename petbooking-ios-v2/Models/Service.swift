//
//  Service.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 24/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class Service: MTLModel, MTLJSONSerializing {

	
	dynamic var id = ""
	dynamic var name = ""
	dynamic var duration = 0
	dynamic var price = 0.0
	dynamic var startDate = ""
	dynamic var startTime = ""
	dynamic var professionalId = ""
	dynamic var professionalName = ""
	dynamic var professionalPicture = ""
	dynamic var services = [SubService]()
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "id",
			"name": "attributes.name",
			"duration": "attributes.duration",
			"price": "attributes.price",
			"services": "attributes.childs"
		]
	}
	
	static func servicesJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: SubService.self)
		
	}
	
}

class SubService: MTLModel, MTLJSONSerializing {
	
	dynamic var name = ""
	dynamic var duration = 0
	dynamic var price = 0.0
	
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"name": "name",
			"duration": "duration",
			"price": "price",
		]
	}
	
}

class ServiceList: MTLModel, MTLJSONSerializing {
	
	dynamic var services = [Service]()
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"services": "data"
		]
	}
	
	static func servicesJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: Service.self)
		
	}
}
