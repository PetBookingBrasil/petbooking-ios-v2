//
//  ScheduleManager.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 01/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import RealmSwift

class ScheduleManager: NSObject {
	
	static let sharedInstance = ScheduleManager()
	
	func createNewSchedule(business:Business) {
		
		let schedule = getSchedule(business: business)
		
		do {
			let realm = try Realm()
			try realm.write {
				
				realm.add(schedule,update: true)
				
			}
		}catch {
			
		}
	}
	
	func removeSchedule(business:Business)  {
		
		let schedule = getSchedule(business: business)
		
		for pet in schedule.petsSchedule {
			deletePet(schedulePet: pet)
		}
		
		do {
			let realm = try Realm()
			try realm.write {
				realm.delete(schedule)
				
			}
		}catch {
		}
	}
	
	func getSchedule(business:Business) -> Schedule {
		
		do {
			let realm = try Realm()
			let predicate = NSPredicate(format: "businessID = '\(business.id)'")
			guard let schedule = realm.objects(Schedule.self).filter(predicate).first else {
				let schedule = Schedule()
				schedule.businessID = business.id
				return schedule
			}
			
			return 	schedule
		} catch {
			//TODO: Handle error
			print(error.localizedDescription)
			return Schedule()
		}
		
	}
	
	
	func addPetToSchedule(business:Business, pet:Pet) {
		
		let schedule = getSchedule(business: business)
		
		guard let schedulePet = getPetFromSchedule(business: business, pet: pet) else {
			let schedulePet = SchedulePet()
			schedulePet.id = SchedulePet.generateId(business: business, pet: pet)
			schedulePet.petId = pet.id
			schedulePet.businessId = business.id
			schedulePet.name = pet.name
			schedulePet.photoThumbUrl = pet.photoThumbUrl
			addPetToSchedule(schedulePet: schedulePet, schedule: schedule)
			return
		}
		
		//addPetToSchedule(schedulePet: schedulePet, schedule: schedule)
	}
	
	
	func addPetToSchedule(schedulePet:SchedulePet, schedule:Schedule) {
		
		do {
			let realm = try Realm()
			try realm.write {
				
				schedule.petsSchedule.append(schedulePet)
				realm.add(schedule,update: true)
				
			}
		}catch {
		}
	}
	
	func removePetFromSchedule(business:Business, pet:Pet) {
		
		guard let schedulePet = getPetFromSchedule(business: business, pet: pet) else {
			return
		}
		
		deletePet(schedulePet: schedulePet)
	}
	
	private func deletePet(schedulePet:SchedulePet) {
		
		for category in schedulePet.categories {
			deleteCategory(scheduleCategory: category)
		}
		
		do {
			let realm = try Realm()
			try realm.write {
				realm.delete(schedulePet)
				
			}
		}catch {
		}
	}
	
	func getPetFromSchedule(business:Business, pet:Pet) -> SchedulePet? {
		
		let schedule = getSchedule(business: business)
		
		let predicate = NSPredicate(format: "id = '\(SchedulePet.generateId(business: business, pet: pet))'")
		guard let schedulePet = schedule.petsSchedule.filter(predicate).first else {
			return nil
		}
		
		return schedulePet
	}
	
	private func addCategoryToSchedule(business:Business, pet:Pet, serviceCategory:ServiceCategory) {
		
		guard	let schedulePet = getPetFromSchedule(business: business, pet: pet) else {
			return
		}
		
		guard let scheduleCategory = getCategoryFromSchedule(business: business, pet: pet, serviceCategory: serviceCategory) else {
			
			let scheduleCategory = ScheduleCategory()
			scheduleCategory.id = ScheduleCategory.generateId(business: business, pet: pet, serviceCategory: serviceCategory)
			scheduleCategory.categoryId = serviceCategory.id
			addCategory(scheduleCategory: scheduleCategory, schedulePet: schedulePet)
			return
		}
		
		//addCategory(scheduleCategory: scheduleCategory, schedulePet: schedulePet)
	}
	
	private func addCategory(scheduleCategory:ScheduleCategory, schedulePet:SchedulePet) {
		
		do {
			let realm = try Realm()
			try realm.write {
				
				schedulePet.categories.append(scheduleCategory)
				realm.add(schedulePet,update: true)
				
			}
		}catch {
		}
	}
	
	func removeCategoryFromSchedule(business:Business, pet:Pet, serviceCategory:ServiceCategory) throws {
		
		guard let scheduleCategory = getCategoryFromSchedule(business: business, pet: pet, serviceCategory: serviceCategory) else {
			return
		}
		
		deleteCategory(scheduleCategory: scheduleCategory)
	}
	
	private	func deleteCategory(scheduleCategory:ScheduleCategory)  {
		
		for service in scheduleCategory.services {
			deleteService(scheduleService: service)
		}
		
		do {
			let realm = try Realm()
			try realm.write {
				realm.delete(scheduleCategory)
			}
		}catch {
		}
	}
	
	func getCategoryFromSchedule(business:Business, pet:Pet, serviceCategory:ServiceCategory) -> ScheduleCategory? {
		
		guard let schedulePet = getPetFromSchedule(business: business, pet: pet) else {
			return nil
		}
		
		let predicate = NSPredicate(format: "id = '\(ScheduleCategory.generateId(business: business, pet: pet, serviceCategory: serviceCategory))'")
		guard let scheduleCategory = schedulePet.categories.filter(predicate).first else {
			return nil
		}
		
		return scheduleCategory
	}
	
	func addServiceToSchedule(business:Business, pet:Pet, serviceCategory:ServiceCategory, service:Service) {
		
		addPetToSchedule(business: business, pet: pet)
		addCategoryToSchedule(business: business, pet: pet, serviceCategory: serviceCategory)
		
		guard let scheduleCategory = getCategoryFromSchedule(business: business, pet: pet, serviceCategory: serviceCategory) else {
			return
		}
		
		guard let scheduleService = getServiceFromSchedule(business: business, pet: pet, serviceCategory: serviceCategory, service: service) else {
			let scheduleService = ScheduleService()
			scheduleService.id = ScheduleService.generateId(business: business, pet: pet, serviceCategory: serviceCategory, service: service)
			scheduleService.serviceId = service.id
			scheduleService.name = service.name
			scheduleService.price = service.price
			scheduleService.professionalId = service.professionalId
			scheduleService.professionalName = service.professionalName
			scheduleService.professionalPicture = service.professionalPicture
			scheduleService.startDate = service.startDate
			scheduleService.startTime = service.startTime
			scheduleService.duration = service.duration
			scheduleService.petId = pet.id
			scheduleService.businessId = business.id
			
			addServiceToSchedule(scheduleService: scheduleService, scheduleCategory: scheduleCategory)
			return
		}
		
		//addServiceToSchedule(scheduleService: scheduleService, scheduleCategory: scheduleCategory)
	}
	
	func addServiceToSchedule(scheduleService:ScheduleService, scheduleCategory:ScheduleCategory) {
		
		do {
			let realm = try Realm()
			try realm.write {
				
				scheduleCategory.services.append(scheduleService)
				realm.add(scheduleCategory,update: true)
				
			}
		}catch {
		}
	}
	
	func removeServiceFromSchedule(business:Business, pet:Pet, serviceCategory:ServiceCategory, service:Service) {
		
		guard let scheduleService = getServiceFromSchedule(business: business, pet: pet, serviceCategory: serviceCategory, service: service) else {
			return
		}
		
		deleteService(scheduleService: scheduleService)
	}
	
	private func deleteService(scheduleService:ScheduleService) {
		
		do {
			let realm = try Realm()
			try realm.write {
				realm.delete(scheduleService.services)
				realm.delete(scheduleService)
				
			}
		}catch {
		}
	}
	
	func getServiceFromSchedule(business:Business, pet:Pet, serviceCategory:ServiceCategory, service:Service) -> ScheduleService? {
		
		guard let scheduleCategory = getCategoryFromSchedule(business: business, pet: pet, serviceCategory: serviceCategory) else {
			return nil
		}
		
		let predicate = NSPredicate(format: "id = '\(ScheduleService.generateId(business: business, pet: pet, serviceCategory: serviceCategory, service: service))'")
		guard let scheduleService = scheduleCategory.services.filter(predicate).first else {
			
			return nil
		}
		
		return scheduleService
	}
	
	func hasServiceFromSchedule(business:Business, pet:Pet, serviceCategory:ServiceCategory, service:Service) -> Bool {
		
		guard let scheduleCategory = getCategoryFromSchedule(business: business, pet: pet, serviceCategory: serviceCategory) else {
			return false
		}
		
		let predicate = NSPredicate(format: "id = '\(ScheduleService.generateId(business: business, pet: pet, serviceCategory: serviceCategory, service: service))'")
		guard let _ = scheduleCategory.services.filter(predicate).first else {
			
			return false
		}
		
		return true
	}
	
	func addSubServiceToSchedule(business:Business, pet:Pet, serviceCategory:ServiceCategory, service:Service, subService:SubService) {
		
		guard let scheduleService = getServiceFromSchedule(business: business, pet: pet, serviceCategory: serviceCategory, service: service) else {
			return
		}
		
		guard let scheduleSubService = getSubServiceFromSchedule(business: business, pet: pet, serviceCategory: serviceCategory, service: service, subService: subService) else {
			let scheduleSubService = ScheduleSubService()
			scheduleSubService.id = ScheduleSubService.generateId(business: business, pet: pet, serviceCategory: serviceCategory, service: service, subService: subService)
			scheduleSubService.subServiceId = subService.id
			scheduleSubService.name = subService.name
			scheduleSubService.price = subService.price
			scheduleSubService.duration = subService.duration
			
			addSubServiceToSchedule(scheduleSubService: scheduleSubService, scheduleService: scheduleService)
			return
		}
		
		//addSubServiceToSchedule(scheduleSubService: scheduleSubService, scheduleService: scheduleService)
	}
	
	func addSubServiceToSchedule(scheduleSubService:ScheduleSubService, scheduleService:ScheduleService ) {
		
		do {
			let realm = try Realm()
			try realm.write {
				
				scheduleService.services.append(scheduleSubService)
				realm.add(scheduleService,update: true)
				
			}
		}catch {
		}
	}
	
	func removeSubServiceFromSchedule(business:Business, pet:Pet, serviceCategory:ServiceCategory, service:Service, subService:SubService) {
		
		guard let scheduleService = getServiceFromSchedule(business: business, pet: pet, serviceCategory: serviceCategory, service: service) else {
			return
		}
		
		guard let scheduleSubService = getSubServiceFromSchedule(business: business, pet: pet, serviceCategory: serviceCategory, service: service, subService: subService) else {
			return
		}
		
		
		deleteSubService(scheduleSubService: scheduleSubService, scheduleService: scheduleService)
	}
	
	private func deleteSubService(scheduleSubService:ScheduleSubService, scheduleService:ScheduleService)  {
		
		guard let index = scheduleService.services.index(of: scheduleSubService) else{
			return
		}
		
		do {
			let realm = try Realm()
			try realm.write {
				
				scheduleService.services.remove(objectAtIndex: index)
				realm.add(scheduleService,update: true)
				
				realm.delete(scheduleSubService)
				
			}
		}catch {
			
		}
	}
	
	func getSubServiceFromSchedule(business:Business, pet:Pet, serviceCategory:ServiceCategory, service:Service, subService:SubService) -> ScheduleSubService? {

		do {
			let realm = try Realm()
			let predicate = NSPredicate(format: "id = '\(ScheduleSubService.generateId(business: business, pet: pet, serviceCategory: serviceCategory, service: service, subService: subService))'")
			guard let scheduleSubService = realm.objects(ScheduleSubService.self).filter(predicate).first else {
				return nil
			}
			
			return 	scheduleSubService
		} catch {
			//TODO: Handle error
			print(error.localizedDescription)
			return nil
		}
		
	}
	
	func getServicesByPet(schedulePet:SchedulePet) -> Results<ScheduleService>? {
		
		do {
			let realm = try Realm()

			let predicate = NSPredicate(format: "petId == '\(schedulePet.petId)'")
			let result = realm.objects(ScheduleService.self).filter(predicate)

			return 	result
		} catch {
			//TODO: Handle error
			print(error.localizedDescription)
			return nil
		}
	}
	
	func getServicesByBusiness(business:Business) -> Results<ScheduleService>? {
		
		do {
			let realm = try Realm()
			
			let predicate = NSPredicate(format: "businessId == '\(business.id)'")
			let result = realm.objects(ScheduleService.self).filter(predicate)
			
			return 	result
		} catch {
			//TODO: Handle error
			print(error.localizedDescription)
			return nil
		}
	}
	
	func cleanSchedule() {
		
		do {
			let realm = try Realm()
			try realm.write {
				
				let schedules = realm.objects(Schedule.self)
				realm.delete(schedules)
				let pets = realm.objects(SchedulePet.self)
				realm.delete(pets)
				let categories = realm.objects(ScheduleCategory.self)
				realm.delete(categories)
				let services = realm.objects(ScheduleService.self)
				realm.delete(services)
				let subServices = realm.objects(ScheduleSubService.self)
				realm.delete(subServices)
				
			}
		}catch {
			
		}
	}
	
}
