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

	dynamic var businessID = ""
	let petsSchedule = List<SchedulePet>()
	
	override static func primaryKey() -> String? {
		return "businessID"
	}
	
}

class SchedulePet: Object {
	
	dynamic var id = ""
	dynamic var petId = ""
	dynamic var name = ""
	dynamic var photoThumbUrl = ""
	let categories = List<ScheduleCategory>()
	dynamic var businessId = ""
	
	override static func primaryKey() -> String? {
		return "id"
	}
	
	static func generateId(business:Business, pet:Pet) -> String {
		
		return "\(business.id)-\(pet.id)"
		
	}
	
}

class ScheduleCategory: Object {
	
	dynamic var id = ""
	dynamic var categoryId = ""
	let services = List<ScheduleService>()
	dynamic var businessId = ""
	
	let parentPet = LinkingObjects(fromType: SchedulePet.self, property: "categories")
	
	override static func primaryKey() -> String? {
		return "id"
	}
	
	static func generateId(business:Business, pet:Pet, serviceCategory:ServiceCategory) -> String {
		
		return "\(business.id)-\(pet.id)-\(serviceCategory.id)"
		
	}
	
}

class ScheduleService: Object {
	
	dynamic var id = ""
	dynamic var serviceId = ""
	dynamic var name = ""
	dynamic var price = 0.0
	dynamic var duration = 0.0
	dynamic var startDate = ""
	dynamic var startTime = ""
	dynamic var professionalId = ""
	dynamic var professionalName = ""
	dynamic var professionalPicture = ""
	let services = List<ScheduleSubService>()
	dynamic var petId = ""
	dynamic var businessId = ""
	
	let parentCategory = LinkingObjects(fromType: ScheduleCategory.self, property: "services")
	
	override static func primaryKey() -> String? {
		return "id"
	}
	
	static func generateId(business:Business, pet:Pet, serviceCategory:ServiceCategory, service:Service) -> String {
		
		return "\(business.id)-\(pet.id)-\(serviceCategory.id)-\(service.id)"
		
	}
	
}

class ScheduleSubService: Object {
	
	dynamic var id = ""
	dynamic var subServiceId = ""
	dynamic var name = ""
	dynamic var price = 0.0
	dynamic var duration = 0
	
	
	override static func primaryKey() -> String? {
		return "id"
	}
	
	static func generateId(business:Business, pet:Pet, serviceCategory:ServiceCategory, service:Service, subService:SubService) -> String {
		
		return "\(business.id)-\(pet.id)-\(serviceCategory.id)-\(service.id)-\(subService.id)"
		
	}
	
}
