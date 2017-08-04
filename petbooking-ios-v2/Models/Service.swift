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
	dynamic var duration = 0.0
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
	
	class func idJSONTransformer() -> ValueTransformer {
		
		let _forwardBlock: MTLValueTransformerBlock? = { (value, success, error) in
			
			if let id = value as? NSNumber {
				return id.stringValue
			}
			
			if let id = value as? String {
				return id
			}
			
			return ""
		}
		
		return MTLValueTransformer(usingForwardBlock: _forwardBlock)
	}
	
}

class SubService: MTLModel, MTLJSONSerializing {
	
	dynamic var id = ""
	dynamic var name = ""
	dynamic var duration = 0
	dynamic var price = 0.0
	
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "id",
			"name": "name",
			"duration": "duration",
			"price": "price",
		]
	}
	
	class func idJSONTransformer() -> ValueTransformer {
		
		let _forwardBlock: MTLValueTransformerBlock? = { (value, success, error) in
			
			if let id = value as? NSNumber {
				return id.stringValue
			}
			
			if let id = value as? String {
				return id
			}
			
			return ""
		}
		
		return MTLValueTransformer(usingForwardBlock: _forwardBlock)
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
