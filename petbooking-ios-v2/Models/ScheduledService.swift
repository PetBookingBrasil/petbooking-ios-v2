//
//  ScheduledService.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 08/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Mantle

class ScheduledService: MTLModel, MTLJSONSerializing {

	dynamic var id = 0

	dynamic var state = ""
	
	dynamic var message = ""
	
	dynamic var startTime = ""
	dynamic var endTime = ""
	dynamic var duration = 0
	
	dynamic var businessId = 0
	dynamic var businessName = ""
	
	dynamic var serviceId = 0
	dynamic var serviceName = ""
	dynamic var serviceDescription = ""
	dynamic var subServices = [SubService]()
	
	dynamic var petId = 0
	
	dynamic var professionalName = ""
	dynamic var professionalId = 0
	dynamic var professionalPicture = ""
	
	dynamic var notes:String = ""
	
	dynamic var withTransportion = false
	
	dynamic var paid = false
	dynamic var price = 0.0
	
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "id",
			"state": "aasm_state",
			"message": "message",
			"startTime": "starts_at",
			"endTime": "ends_at",
			"duration": "duration",
			"professionalName": "employment_name",
			"professionalId": "employment_id",
			"professionalPicture": "employment_avatar.thumb.url",
			"paid": "paid",
			"businessId": "business_id",
			"businessName": "business_name",
			"serviceId": "service.id",
			"price": "service.price",
			"serviceName": "service.name",
			"serviceDescription": "service.description",
			"subServices": "service.additional_services",
			"petId": "pet_id",
			"notes": "notes",
			"withTransportion": "with_transportation"
		]
	}
	
	static func subServicesJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: SubService.self)
		
	}
}

class ScheduledPet: MTLModel, MTLJSONSerializing {
	
	dynamic var id = 0
	dynamic var name = ""
	dynamic var type = ""
	dynamic var photoThumbUrl = ""
	dynamic var services = [ScheduledService]()
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"id": "id",
			"name": "name",
			"type":"kind",
			"photoThumbUrl": "photo.thumb.url",
			"services": "events"
		]
	}
	
	static func servicesJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: ScheduledService.self)
		
	}
}

class ScheduledDate: MTLModel, MTLJSONSerializing {
	
	dynamic var date = Date()
	dynamic var dateKey = ""
	dynamic var scheduledPets = [ScheduledPet]()
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"date": "date",
			"dateKey": "date",
			"scheduledPets": "pets"
		]
	}
	
	static func dateJSONTransformer() -> ValueTransformer {
		
		let _forwardBlock: MTLValueTransformerBlock? = { (value, success, error) in
			
			if let dateString = value as? String{
				
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd"
				
				guard let date = dateFormatter.date(from: dateString) else {
					return Date()
				}
				
				return date
				
			}
			
			return Date()
			
		}
		
		return MTLValueTransformer(usingForwardBlock: _forwardBlock)
		
	}
	
	static func scheduledPetsJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: ScheduledPet.self)
		
	}
}

class ScheduledServiceList: MTLModel, MTLJSONSerializing {
	
	var scheduledDates = [ScheduledDate]()
	dynamic var page = 0
	
	static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
		return [
			"scheduledDates": "data"
		]
	}
	
	static func scheduledDatesJSONTransformer() -> ValueTransformer {
		
		return MTLJSONAdapter.arrayTransformer(withModelClass: ScheduledDate.self)
		
	}
}
