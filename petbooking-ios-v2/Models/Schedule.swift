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
	
	dynamic var petId = ""
	let categories = List<ScheduleCategory>()
	
	override static func primaryKey() -> String? {
		return "petId"
	}
	
	static func generateId(business:Business, pet:Pet) -> String {
		
		return "\(business.id)-\(pet.id)"
		
	}
	
}

class ScheduleCategory: Object {
	
	dynamic var categoryId = ""
	let services = List<ScheduleService>()
	
	override static func primaryKey() -> String? {
		return "categoryId"
	}
	
	static func generateId(business:Business, pet:Pet, serviceCategory:ServiceCategory) -> String {
		
		return "\(business.id)-\(pet.id)-\(serviceCategory.id)"
		
	}
	
}

class ScheduleService: Object {
	
	dynamic var serviceId = ""
	dynamic var name = ""
	dynamic var price = 0.0
	let services = List<ScheduleSubService>()
	
	override static func primaryKey() -> String? {
		return "serviceId"
	}
	
	static func generateId(business:Business, pet:Pet, serviceCategory:ServiceCategory, service:Service) -> String {
		
		return "\(business.id)-\(pet.id)-\(serviceCategory.id)-\(service.id)"
		
	}
	
}

class ScheduleSubService: Object {
	
	dynamic var id = ""
	dynamic var name = ""
	dynamic var price = 0.0
	
	override static func primaryKey() -> String? {
		return "id"
	}
	
	static func generateId(business:Business, pet:Pet, serviceCategory:ServiceCategory, service:Service, subService:SubService) -> String {
		
		return "\(business.id)-\(pet.id)-\(serviceCategory.id)-\(service.id)-\(service.name)"
		
	}
	
}
