//
//  PetbookingAPI.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 30/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import Alamofire
import Mantle

class PetbookingAPI: NSObject {
	
	static let HTTP_PROTOCOL = "https://"
	
	static let BASE_URL = Bundle.main.infoDictionary!["API_BASE_URL_ENDPOINT"] as! String
	
	static let AUTH_KEY = Bundle.main.infoDictionary!["AUTH_KEY"] as! String
	
	static let API_VERSION = "/v2"
	
	static let API_BASE_URL = "\(HTTP_PROTOCOL)\(BASE_URL)\(API_VERSION)"
	
	var auth_headers: HTTPHeaders!
	
	let consumer_headers: HTTPHeaders!
	
	
	static let sharedInstance = PetbookingAPI()
	
	override init() {
		
		var token = ""
		if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
			token = consumer.token
		}
		
		auth_headers	= [
			"Authorization": "Bearer \(token)",
			"Content-Type": "application/vnd.api+json"
		]
		
		consumer_headers	= [
			"Content-Type": "application/vnd.api+json"
		]
	}
	
}

// MARK: Login

extension PetbookingAPI {
	
	func getConsumer(completion: @escaping (_ success: Bool, _ message: String) -> Void) {
		
		let parameters: Parameters = [
			"data": ["type":"consumers", "attributes":["uuid":PetbookingAPI.AUTH_KEY]]
		]
		
		Alamofire.request("\(PetbookingAPI.API_BASE_URL)/consumers/auth/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: consumer_headers).responseJSON { (response) in
			
			switch response.result{
			case .success(let jsonObject):
				print(jsonObject)
				
				
				do {
					
					if let dic = jsonObject as? [String: Any] {
						let consumer = try MTLJSONAdapter.model(of: Consumer.self, fromJSONDictionary: dic) as! Consumer
						try SessionManager.sharedInstance.saveConsumer(consumer: consumer)
					}
					
					
				} catch {
					
				}
				
				break
			case .failure(let error):
				print(error)
				break
			}
			
		}
	}
	
	func login(_ parameters: Parameters, completion: @escaping (_ success: Bool, _ message: String) -> Void) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/sessions", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {
							
							let session = try MTLJSONAdapter.model(of: Session.self, fromJSONDictionary: dic) as! Session
							
							if session.errors.count == 0 {
								
								try SessionManager.sharedInstance.saveSession(session: session)
								
								completion(true, "")
							} else {
								completion(false, "")
							}
							
						} catch {
							completion(false, error.localizedDescription)
						}
					} else {
						completion(false, "")
					}
					break
				case .failure(let error):
					print(error)
					completion(false, error.localizedDescription)
					break
				}
				
			}
		} else {
			
			getConsumer(completion: { (success, message) in
				
				if success {
					self.login(parameters, completion: completion)
				} else {
					
					completion(false, "")
					
				}
				
			})
			
		}
		
	}
	
	func loginWithFacebook(_ facebookAccessToken:String,  completion: @escaping (_ success: Bool, _ message: String) -> Void) {
		
		let parameters: Parameters = [
			"data": ["type":"sessions", "attributes":["provider":"facebook", "provider_token":facebookAccessToken]]
			
		]
		
		login(parameters, completion: completion)
		
	}
	
	func loginWithEmail(_ email:String, password:String,  completion: @escaping (_ success: Bool, _ message: String) -> Void) {
		
		let parameters: Parameters = [
			"data": ["type":"sessions", "attributes":["provider":"b2beauty", "email":email, "password":password]]
			
		]
		
		login(parameters, completion: completion)
		
	}
	
	func resetPassword(_ email:String, completion: @escaping (_ success: Bool, _ message: String) -> Void) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			
			let parameters: Parameters = [
				"data": ["type":"users", "attributes":["email":email]]
				
			]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/recover-password", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: auth_headers).responseJSON { (response) in
				
				switch response.response!.statusCode {
				case 200,
				     201,
				     202,
				     204:
					completion(true, "")
					break
				default:
					completion(false, "")
					break
				}
			}
		} else {
			
			getConsumer(completion: { (success, message) in
				
				if success {
					self.resetPassword(email, completion: completion)
				} else {
					
					completion(false, "")
					
				}
				
			})
		}
	}
}

// MARK: User

extension PetbookingAPI {
	
	func createUser(name:String, cpf:String, birthday:String, email:String, mobile:String, zipcode:String, street:String, streetNumber:String, neighborhood:String, city:String, state:String, password:String, provider:String, providerToken:String, avatar:String, _ completion: @escaping (_ user: Bool, _ message: String) -> Void) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			
			let parameters: Parameters = [
				"data": ["type":"users", "attributes":["provider":provider, "provider_token":providerToken, "email":email, "password":password, "name":name, "phone":mobile, "cpf":cpf, "city":city, "state":state, "zipcode":zipcode, "street":street, "street_number":streetNumber, "neighborhood":neighborhood, "avatar":avatar]]
				
			]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {
							
							let user = try MTLJSONAdapter.model(of: User.self, fromJSONDictionary: dic) as! User
							
							if user.errors.count == 0 {
								
								try UserManager.sharedInstance.saveUser(user: user)
								
								if providerToken.isEmpty {
									self.loginWithEmail(email, password: password, completion: { (success, message) in
										
										completion(success, message)
										
									})
								} else {
									self.loginWithFacebook(providerToken, completion: { (success, message) in
										completion(success, message)
									})
								}
							} else {
								completion(false, "")
							}
							
						} catch {
							completion(false, error.localizedDescription)
						}
					} else {
						completion(false, "")
					}
					break
				case .failure(let error):
					print(error)
					completion(false, error.localizedDescription)
					break
				}
				
			}
		} else {
			
			getConsumer(completion: { (success, message) in
				
				if success {
					self.createUser(name: name, cpf: cpf, birthday: birthday, email: email, mobile: mobile, zipcode: zipcode, street: street, streetNumber: streetNumber, neighborhood: neighborhood, city: city, state: state, password: password, provider: provider, providerToken: providerToken, avatar: avatar, completion)
				} else {
					
					completion(false, "")
					
				}
				
			})
		}
	}
	
	func userInfo(_ completion: @escaping (_ user: User?, _ message: String) -> Void) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			var authToken = ""
			var userId = 0
			if let session = SessionManager.sharedInstance.getCurrentSession() {
				authToken = session.authToken
				userId = session.userId
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			self.auth_headers.updateValue("Token token=\"\(authToken)\"", forKey: "X-Petbooking-Session-Token")
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/\(userId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {
							
							let user = try MTLJSONAdapter.model(of: User.self, fromJSONDictionary: dic) as! User
							
							try UserManager.sharedInstance.saveUser(user: user)
							
							completion(user, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
					break
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
					break
				}
				
			}
		} else {
			getConsumer(completion: { (success, message) in
				
				if success {
					self.userInfo(completion)
				} else {
					
					completion(nil, "")
					
				}
				
			})
		}
	}
}

// MARK: User

extension PetbookingAPI {
	
	func getUserPets(completion: @escaping (_ petList: PetList?, _ message: String) -> Void) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			var authToken = ""
			var userId = 0
			if let session = SessionManager.sharedInstance.getCurrentSession() {
				authToken = session.authToken
				userId = session.userId
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			self.auth_headers.updateValue("Token token=\"\(authToken)\"", forKey: "X-Petbooking-Session-Token")
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/\(userId)/pets", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {
							let petList = try MTLJSONAdapter.model(of: PetList.self, fromJSONDictionary: dic) as! PetList
							
							
							completion(petList, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
					break
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
					break
				}
				
			}
		} else
		{
			getConsumer(completion: { (success, message) in
				
				if success {
					self.getUserPets(completion: completion)
				} else {
					
					completion(nil, "")
					
				}
				
			})
		}
	}
}

// MARK: Pets

extension PetbookingAPI {
	
	func getBreedList(petType:String, completion: @escaping (_ breedList: BreedList?, _ message: String) -> Void ) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/breeds/\(petType)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {
							let breedList = try MTLJSONAdapter.model(of: BreedList.self, fromJSONDictionary: dic) as! BreedList
							
							
							completion(breedList, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
					break
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
					break
				}
				
			}
		} else
		{
			getConsumer(completion: { (success, message) in
				
				if success {
					self.getBreedList(petType: petType, completion: completion)
				} else {
					
					completion(nil, "")
					
				}
				
			})
		}
	}
	
	func createPet(pet:Pet, completion: @escaping (_ petList: PetList?, _ message: String) -> Void) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			var authToken = ""
			var userId = 0
			if let session = SessionManager.sharedInstance.getCurrentSession() {
				authToken = session.authToken
				userId = session.userId
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			self.auth_headers.updateValue("Token token=\"\(authToken)\"", forKey: "X-Petbooking-Session-Token")
			
			let parameters: Parameters = [
				"data": ["type":"pets", "attributes":["size":pet.size, "breed_id":pet.breedId, "user_id":userId, "name":pet.name, "gender":pet.gender, "mood":pet.mood, "description":pet.petDescription, "birth_date":pet.birthday, "coat_type":pet.coatSize, "photo":pet.photoUrl]]
				
			]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/\(userId)/pets", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {
							let petList = try MTLJSONAdapter.model(of: PetList.self, fromJSONDictionary: dic) as! PetList
							
							
							completion(petList, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
					break
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
					break
				}
				
			}
		} else
		{
			getConsumer(completion: { (success, message) in
				
				if success {
					self.getUserPets(completion: completion)
				} else {
					
					completion(nil, "")
					
				}
			})
		}
	}
	
	
}
