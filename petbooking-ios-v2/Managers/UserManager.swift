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
	
	func getCurrentUser() -> User? {
		
		do {
			let realm = try Realm()
			guard let userRealm = 	realm.objects(UserRealm.self).first else {
				return nil
			}
			
			let user = User()

			user?.userId = userRealm.userId
			user?.acceptsEmail = userRealm.acceptsEmail
			user?.acceptsPush = userRealm.acceptsPush
			user?.acceptsSms = userRealm.acceptsSms
			user?.authToken = userRealm.authToken
			user?.avatarUrlLarge = userRealm.avatarUrlLarge
			user?.avatarUrlMedium = userRealm.avatarUrlMedium
			user?.avatarUrlThumb = userRealm.avatarUrlThumb
			user?.avatarUrlTiny = userRealm.avatarUrlTiny
			user?.birthday = userRealm.birthday
			user?.city = userRealm.city
			user?.cpf = userRealm.cpf
			user?.email = userRealm.email
			user?.gender = userRealm.gender
			user?.name = userRealm.name
			user?.neighborhood = userRealm.neighborhood
			user?.nickname = userRealm.nickname
			user?.phone = userRealm.phone
			user?.state = userRealm.state
			user?.street = userRealm.street
			user?.streetNumber = userRealm.streetNumber
			user?.zipcode = userRealm.zipcode
			user?.validForScheduling = userRealm.validForScheduling
			user?.complement = userRealm.complement
			
			return 	user
		} catch _ as NSError {
			//TODO: Handle error
			
			return nil
		}
		
	}
	
	func saveUser(user:User) throws {
		
		let userRealm = UserRealm()
		userRealm.userId = user.userId
		userRealm.acceptsEmail = user.acceptsEmail
		userRealm.acceptsPush = user.acceptsPush
		userRealm.acceptsSms = user.acceptsSms
		userRealm.authToken = user.authToken
		userRealm.avatarUrlLarge = user.avatarUrlLarge
		userRealm.avatarUrlMedium = user.avatarUrlMedium
		userRealm.avatarUrlThumb = user.avatarUrlThumb
		userRealm.avatarUrlTiny = user.avatarUrlTiny
		userRealm.birthday = user.birthday
		userRealm.city = user.city
		userRealm.cpf = user.cpf
		userRealm.email = user.email
		userRealm.gender = user.gender
		userRealm.name = user.name
		userRealm.neighborhood = user.neighborhood
		userRealm.nickname = user.nickname
		userRealm.phone = user.phone
		userRealm.state = user.state
		userRealm.street = user.street
		userRealm.streetNumber = user.streetNumber
		userRealm.zipcode = user.zipcode
		userRealm.validForScheduling = user.validForScheduling
		userRealm.complement = user.complement
		
		do {
			let realm = try Realm()
			
			try realm.write {
				
				
				realm.add(userRealm,update: true)
	
			}
		}catch {
			throw error
		}
	}
	
	func saveAPNSToken(tokenValue:String) {
		
		let token = Token()
		token.token = tokenValue
		token.type = "APNS"
		
		
		do {
			let realm = try Realm()
			try realm.write {
				
				realm.add(token, update: true)
				
			}
		}catch {
			print(error.localizedDescription)
		}
	}
	
	func getAPNSToken() -> Token? {
		
		do {
			let realm = try Realm()
			let predicate = NSPredicate(format: "type = 'APNS'")
			guard let token = realm.objects(Token.self).filter(predicate).first else {
				return nil
			}
			
			return 	token
		} catch {
			//TODO: Handle error
			print(error.localizedDescription)
			return nil
		}
		
	}
	
	
	func logOut() {
		
		do {
			let realm = try Realm()
			try realm.write {
				
				let objects = realm.objects(UserRealm.self)
				realm.delete(objects)
				let session = realm.objects(SessionRealm.self)
				realm.delete(session)
								
			}
		}catch {
			
		}
	}

}
