//
//  Schedule.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 01/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Schedule: Object {

	@objc dynamic var businessID = ""
	let petsSchedule = List<SchedulePet>()
	
	override static func primaryKey() -> String? {
		return "businessID"
	}
}

class SchedulePet: Object {
	
	@objc dynamic var id = ""
	@objc dynamic var petId = ""
	@objc dynamic var name = ""
	@objc dynamic var type = ""
	@objc dynamic var photoThumbUrl = ""
	let categories = List<ScheduleCategory>()
	@objc dynamic var businessId = ""
	
	override static func primaryKey() -> String? {
		return "id"
	}
	
	static func generateId(business:Business, pet:Pet) -> String {
		return "\(business.id)-\(pet.id)"
	}
}

class ScheduleCategory: Object {
	
	@objc dynamic var id = ""
	@objc dynamic var categoryId = ""
	let services = List<ScheduleService>()
	@objc dynamic var businessId = ""
	
	let parentPet = LinkingObjects(fromType: SchedulePet.self, property: "categories")
	
	override static func primaryKey() -> String? {
		return "id"
	}
	
	static func generateId(business:Business, pet:Pet, serviceCategory:ServiceCategory) -> String {
		return "\(business.id)-\(pet.id)-\(serviceCategory.id)"
	}
}

class ScheduleService: Object {
	
	@objc dynamic var id = ""
	@objc dynamic var serviceId = ""
	@objc dynamic var name = ""
	@objc dynamic var price = 0.0
	@objc dynamic var duration = 0.0
	@objc dynamic var startDate = ""
	@objc dynamic var startTime = ""
	@objc dynamic var professionalId = ""
	@objc dynamic var professionalName = ""
	@objc dynamic var professionalPicture = ""
	let services = List<ScheduleSubService>()
	@objc dynamic var petId = ""
	@objc dynamic var businessId = ""
	
	let parentCategory = LinkingObjects(fromType: ScheduleCategory.self, property: "services")
	
	override static func primaryKey() -> String? {
		return "id"
	}
	
	static func generateId(business:Business, pet:Pet, serviceCategory:ServiceCategory, service:Service) -> String {
		return "\(business.id)-\(pet.id)-\(serviceCategory.id)-\(service.id)[\(service.startDate)-\(service.startTime)]"
	}
}

class ScheduleSubService: Object {
	
	@objc dynamic var id = ""
	@objc dynamic var subServiceId = ""
	@objc dynamic var name = ""
	@objc dynamic var price = 0.0
	@objc dynamic var duration = 0
	
	override static func primaryKey() -> String? {
		return "id"
	}
	
	static func generateId(business:Business, pet:Pet, serviceCategory:ServiceCategory, service:Service, subService:SubService) -> String {
		return "\(business.id)-\(pet.id)-\(serviceCategory.id)-\(service.id)-\(subService.id)"
	}
}
