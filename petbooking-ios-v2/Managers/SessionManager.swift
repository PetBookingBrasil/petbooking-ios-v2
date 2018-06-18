//
//  SessionManager.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 01/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import RealmSwift

class SessionManager: NSObject {

	static let sharedInstance = SessionManager()
	
	func getCurrentConsumer() -> Consumer? {
		
		do {
			let realm = try Realm()
			guard let consumerRealm = realm.objects(ConsumerRealm.self).first else {
				return nil
			}
			
			let consumer = Consumer()
			consumer?.token = consumerRealm.token
			consumer?.tokenExpiresAt = consumerRealm.tokenExpiresAt
			
			return 	consumer
		} catch {
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
		} catch {
			throw error
		}
	}
	
	func isConsumerValid() -> Bool {
		guard let consumer = getCurrentConsumer() else { return false }
        
		return consumer.isValid()
	}
	
	func getCurrentSession() -> Session? {
		
		do {
			let realm = try Realm()
			guard let sessionRealm = realm.objects(SessionRealm.self).first else {
				return nil
			}
			
			let session = Session()
			session?.userId = sessionRealm.userId
			session?.authToken = sessionRealm.authToken
			session?.tokenExpiresAt = sessionRealm.tokenExpiresAt
			session?.validForScheduling = sessionRealm.validForScheduling

            return 	session
		} catch {
			return nil
		}
	}
	
	func saveSession(session:Session) throws {
		
		let sessionRealm = SessionRealm()
		sessionRealm.userId = session.userId
		sessionRealm.authToken = session.authToken
		sessionRealm.tokenExpiresAt = session.tokenExpiresAt
		sessionRealm.validForScheduling = session.validForScheduling
		
		do {
			let realm = try Realm()
			try realm.write {
				
				let objects = realm.objects(SessionRealm.self)
				realm.delete(objects)
				realm.add(sessionRealm,update: true)
				
			}
		} catch {
			throw error
		}
	}
}
