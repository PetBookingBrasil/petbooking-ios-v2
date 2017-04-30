//
//  UserManager.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 30/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import RealmSwift

class UserManager: NSObject {
	
	static let sharedInstance = UserManager()
	
	func getCurrentConsumer() -> Consumer? {
		
		do {
			let realm = try Realm()
			guard let consumerRealm = 	realm.objects(ConsumerRealm.self).first else {
				return nil
			}
			
			let consumer = Consumer()
			consumer?.token = consumerRealm.token
			consumer?.tokenExpiresAt = consumerRealm.tokenExpiresAt
			
			return 	consumer
		} catch _ as NSError {
			//TODO: Handle error
			
			return nil
		}
		
	}
	
	func saveConsumer(consumer:Consumer) throws {
		
		let consumerRealm = ConsumerRealm()
		consumerRealm.token = consumer.token
		consumerRealm.tokenExpiresAt = consumer.tokenExpiresAt
		
		do {
			let realm = try Realm()
			try realm.write {
				
				let objects = realm.objects(ConsumerRealm.self)
				realm.delete(objects)
				
				realm.add(consumerRealm,update: true)
				
			}
		}catch {
			throw error
		}
	}

}
