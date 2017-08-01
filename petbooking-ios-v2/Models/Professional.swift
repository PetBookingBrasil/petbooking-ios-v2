//
//  Professional.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 31/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class Professional: MTLModel, MTLJSONSerializing {
	
	dynamic var id = ""
	dynamic var name = ""
	dynamic var serviceCount = 0
	dynamic var slug = ""
	dynamic var birthday:String = ""
	dynamic var cpf:String = ""
	dynamic var email:String = ""
	dynamic var gender:String = ""
	dynamic var nickname:String = ""
	dynamic var phone:String = ""
	dynamic var schedule:[String: [String]] = [:]
	dynamic var photoUrl = ""
	dynamic var photoMediumUrl = ""
	dynamic var photoThumbUrl = ""
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "id",
			"name": "attributes.name",
			"serviceCount": "attributes.service_count",
			"slug": "attributes.slug",
			"birthday": "data.attributes.birthday",
			"cpf": "attributes.cpf",
			"email": "attributes.email",
			"gender": "attributes.gender",
			"nickname": "attributes.nickname",
			"phone": "attributes.phone",
			"schedule":"attributes.available_slots",
			"photoUrl": "attributes.photo.url",
			"photoMediumUrl": "attributes.photo.medium.url",
			"photoThumbUrl": "attributes.photo.thumb.url"

		]
	}
	
	static func scheduleJSONTransformer() -> ValueTransformer {
		
		let _forwardBlock: MTLValueTransformerBlock? = { (value, success, error) in
			
			var schedule:[String: [String]] = [:]
			
			if let array = value as? [Dictionary<String, Any>]{
				
				for dic in array {
					
					do {
					let times = try MTLJSONAdapter.model(of: Times.self, fromJSONDictionary: dic) as! Times
						
						schedule.updateValue(times.times, forKey: times.date)
						
					} catch {
						
					}
				}
			}
			
			return schedule
			
		}
		
		return MTLValueTransformer(usingForwardBlock: _forwardBlock)
		
	}
}

class ProfessionalList: MTLModel, MTLJSONSerializing {
	
	dynamic var professionals = [Professional]()
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"professionals": "data"
		]
	}
	
	static func professionalsJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: Professional.self)
		
	}
	
}

class Times: MTLModel, MTLJSONSerializing {
	
	dynamic var date = ""
	dynamic var times = [String]()
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"date": "date",
			"times": "times"
		]
	}
	
}
