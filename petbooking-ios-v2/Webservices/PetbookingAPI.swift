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
import CoreLocation

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
		
		var language = ""
		if let langStr = Locale.current.languageCode {
			language = langStr
		}
		
		auth_headers = ["Authorization": "Bearer \(token)", "Content-Type": "application/vnd.api+json", "X-BDT-language": language]
		consumer_headers = ["Content-Type": "application/vnd.api+json"]
	}
}

// MARK: Login
extension PetbookingAPI {
    
    func postPhoneNumberClick(from businessName: String, completion: @escaping (_ success: Bool, _ message: String) -> Void) {
        
        if SessionManager.sharedInstance.isConsumerValid() {
            guard let session = SessionManager.sharedInstance.getCurrentSession() else { return }

            var token = ""
            if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
                token = consumer.token
            }
            
            self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
            self.auth_headers.updateValue("Token token=\"\(session.authToken)\"", forKey: "X-Petbooking-Session-Token")
            
            Alamofire.request("\(PetbookingAPI.API_BASE_URL)/api/v2/count_phone_click_for/\(businessName)",
                method: .post,
                parameters: nil,
                encoding: JSONEncoding.default,
                headers: auth_headers).responseJSON { (response) in
                    completion(true, "")
            }
        } else {
            getConsumer { (success, message) in
                if success {
                    self.postPhoneNumberClick(from: businessName, completion: completion)
                } else {
                    completion(false, "")
                }
            }
        }
    }
	
	func getConsumer(completion: @escaping (_ success: Bool, _ message: String) -> Void) {
		
		let parameters: Parameters = ["data": ["type": "consumers", "attributes": ["uuid": PetbookingAPI.AUTH_KEY]]]

        Alamofire.request("\(PetbookingAPI.API_BASE_URL)/consumers/auth/",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: consumer_headers).responseJSON { (response) in
			
			switch response.result {
			case .success(let jsonObject):

				do {
					if let dic = jsonObject as? [String: Any] {
						let consumer = try MTLJSONAdapter.model(of: Consumer.self, fromJSONDictionary: dic) as! Consumer
						try SessionManager.sharedInstance.saveConsumer(consumer: consumer)
						completion(true, "")
					}
				} catch {
					completion(true, error.localizedDescription)
				}

            case .failure(let error):
				print(error)
				completion(true, error.localizedDescription)
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
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/sessions",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: auth_headers).responseJSON { (response) in
				
				switch response.result {
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
				case .failure(let error):
					print(error)
					completion(false, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
                if success {
					self.login(parameters, completion: completion)
				} else {
					completion(false, "")
				}
			}
		}
	}
	
    func loginWithFacebook(_ facebookAccessToken: String, completion: @escaping (_ success: Bool, _ message: String) -> Void) {
		let parameters: Parameters = ["data": ["type": "sessions",
                                               "attributes": ["provider": "facebook",
                                                              "provider_token": facebookAccessToken]]]
		
		login(parameters, completion: completion)
	}
	
	func loginWithEmail(_ email:String, password:String,  completion: @escaping (_ success: Bool, _ message: String) -> Void) {
		let parameters: Parameters = ["data": ["type": "sessions", "attributes": ["provider": "b2beauty", "email": email, "password": password]]]
		
		login(parameters, completion: completion)
	}
	
	func resetPassword(_ email:String, completion: @escaping (_ success: Bool, _ message: String) -> Void) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			
			let parameters: Parameters = ["data": ["type":"users", "attributes":["email":email]]]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/recover-password",
                method: .post, parameters:
                parameters,
                encoding: JSONEncoding.default,
                headers: auth_headers).responseJSON { (response) in
				
				switch response.response!.statusCode {
				case 200, 201, 202, 204:
					completion(true, "")
				default:
					completion(false, "")
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.resetPassword(email, completion: completion)
				} else {
					completion(false, "")
				}
			}
		}
	}
}

// MARK: User

extension PetbookingAPI {
	
	func createUser(name: String, email: String, mobile: String, password: String, provider: String, providerToken: String, avatar: String?, _ completion: @escaping (_ user: Bool, _ message: String) -> Void) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			var token = ""
            
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
            
            var attributes = ["provider": provider,
                              "provider_token": providerToken,
                              "email": email,
                              "password": password,
                              "name": name,
                              "phone": mobile]
            
            if let avatar = avatar {
                attributes["avatar"] = avatar
            }
			
			let parameters: Parameters = ["data": ["type": "users",
                                                   "attributes": attributes]]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: auth_headers).responseJSON { (response) in
				
				switch response.result {
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						do {
							let user = try MTLJSONAdapter.model(of: User.self, fromJSONDictionary: dic) as! User
							
							if user.errors.count == 0 {
								try UserManager.sharedInstance.saveUser(user: user)
								if providerToken.isEmpty {
									self.loginWithEmail(email, password: password, completion: completion)
								} else {
                                    self.loginWithFacebook(providerToken, completion: completion)
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
				case .failure(let error):
					print(error)
					completion(false, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.createUser(name: name, email: email, mobile: mobile, password: password, provider: provider, providerToken: providerToken, avatar: avatar, completion)
				} else {
					completion(false, "")
				}
			}
		}
	}
	
    func updateUser(name: String, email: String, mobile: String, avatar: String, completion: @escaping (_ user: Bool, _ message: String) -> Void) {
		
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
			
            let parameters: Parameters = ["data": ["type": "users", "id": "\(userId)",
                                                    "attributes": ["email": email,
                                                                   "name": name,
                                                                   "phone": mobile,
                                                                   "avatar": avatar]]]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/\(userId)",
                method: .put,
                parameters: parameters,
                encoding: JSONEncoding.prettyPrinted,
                headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {
							let user = try MTLJSONAdapter.model(of: User.self, fromJSONDictionary: dic) as! User
							
							if user.errors.count == 0 {
								try UserManager.sharedInstance.saveUser(user: user)
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
				case .failure(let error):
					print(error)
					completion(false, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.updateUser(name: name, email: email, mobile: mobile, avatar: avatar, completion: completion)
                } else {
					completion(false, "")
                }
			}
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
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.userInfo(completion)
				} else {
					completion(nil, "")
                }
			}
		}
	}
	
	func getUserInfo(userId:Int, _ completion: @escaping (_ user: User?, _ message: String) -> Void) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			var authToken = ""
			if let session = SessionManager.sharedInstance.getCurrentSession() {
				authToken = session.authToken
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
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.getUserInfo(userId: userId,completion)
				} else {
					completion(nil, "")
				}
			}
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
					if let dic = jsonObject as? [AnyHashable : Any] {
                        do {
                            let petList = try MTLJSONAdapter.model(of: PetList.self, fromJSONDictionary: dic) as! PetList
                            completion(petList, "")
                        } catch {
                            completion(nil, error.localizedDescription)
                        }
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					completion(nil, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.getUserPets(completion: completion)
				} else {
					completion(nil, "")
				}
			}
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
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/breeds/\(petType)?page[size]=250", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: auth_headers).responseJSON { (response) in
				
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
				case .failure(let error):
					completion(nil, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.getBreedList(petType: petType, completion: completion)
				} else {
					completion(nil, "")
				}
			}
		}
	}
	
	func createPet(pet:Pet, completion: @escaping (_ pet: Pet?, _ message: String) -> Void) {
		
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
			
			let parameters: Parameters = ["data":
                                            ["type": "pets",
                                             "attributes": ["size": pet.size,
                                                            "breed_id": pet.breedId,
                                                            "user_id": userId,
                                                            "name": pet.name,
                                                            "gender": pet.gender,
                                                            "mood": pet.mood,
                                                            "description": pet.petDescription,
                                                            "birth_date": pet.birthday,
                                                            "coat_type": pet.coatSize,
                                                            "castrated": pet.castrated,
                                                            "coat_colors": [pet.coatColor],
                                                            "chip_id": pet.chipNumber,
                                                            "photo": pet.photoUrl]]]
            
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/\(userId)/pets", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: auth_headers).responseJSON { (response) in
				
				switch response.result {
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						do {
							let pet = try MTLJSONAdapter.model(of: Pet.self, fromJSONDictionary: dic) as! Pet
							completion(pet, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.createPet(pet:pet,completion: completion)
				} else {
					completion(nil, "")
				}
			}
		}
	}
	
	func updatePet(pet:Pet, completion: @escaping (_ pet: Pet?, _ message: String) -> Void) {
		
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
			
            let parameters: Parameters = ["data":
                                            ["type": "pets",
                                             "id": pet.id,
                                             "attributes": ["size": pet.size,
                                                            "breed_id": pet.breedId,
                                                            "name": pet.name,
                                                            "gender": pet.gender,
                                                            "mood": pet.mood,
                                                            "description": pet.petDescription,
                                                            "birth_date": pet.birthday,
                                                            "coat_type": pet.coatSize,
                                                            "castrated": pet.castrated,
                                                            "coat_colors": [pet.coatColor],
                                                            "chip_id": pet.chipNumber,
                                                            "photo": pet.photoUrl]]]

			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/\(userId)/pets/\(pet.id)", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					
					if let dic = jsonObject as? [String: Any] {
						do {
							let pet = try MTLJSONAdapter.model(of: Pet.self, fromJSONDictionary: dic) as! Pet
							completion(pet, "")
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					completion(nil, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.createPet(pet:pet,completion: completion)
				} else {
					completion(nil, "")
				}
			}
		}
	}
	
	func deletePet(pet:Pet, completion: @escaping (_ pet: Pet?, _ message: String) -> Void) {
		
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
			
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/\(userId)/pets/\(pet.id)", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					
					if let dic = jsonObject as? [String: Any] {
						do {
							let pet = try MTLJSONAdapter.model(of: Pet.self, fromJSONDictionary: dic) as! Pet
							completion(pet, "")
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
				}
				
			}
		} else {
			getConsumer { (success, message) in
                if success {
					self.deletePet(pet:pet,completion: completion)
				} else {
					completion(nil, "")
				}
			}
		}
	}
}

// MARK: Business

extension PetbookingAPI {
    
    func getBusinessList(coordinate: CLLocationCoordinate2D, service: ServiceCategory?, page: Int = 1, completion: @escaping (_ businessList: BusinessList?, _ message: String) -> Void ) {
        
        if let service = service {
            getBusinessList(from: service, in: coordinate, page: page, completion: completion)
        } else {
            getBusinessList(coordinate: coordinate, page: page, completion: completion)
        }
    }
    
	
    func getBusinessList(coordinate: CLLocationCoordinate2D, page: Int = 1, completion: @escaping (_ businessList: BusinessList?, _ message: String) -> Void ) {
        
        if SessionManager.sharedInstance.isConsumerValid() {
            var token = ""
            if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
                token = consumer.token
            }
            
            guard let session = SessionManager.sharedInstance.getCurrentSession() else {
                return
            }
            
            self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
            self.auth_headers.updateValue("Token token=\"\(session.authToken)\"", forKey: "X-Petbooking-Session-Token")
            
            let coords = "\(coordinate.latitude),\(coordinate.longitude)"
            
            let parameters: Parameters = ["user_id": session.userId,
                                          "coords": coords,
                                          "fields[businesses]": "id,name,slug,location,distance,street,street_number,imported,neighborhood,rating_average,rating_count,favorite_count,cover_image,pictures,transportation_fee,user_favorite,bitmask_values,phone,city,description,state,website,facebook_fanpage,twitter_profile,googleplus_profile,instagram,snapchat",
                                          "page[number]": page,
                                          "page[size]": 20]
            
            Alamofire.request("\(PetbookingAPI.API_BASE_URL)/businesses", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: auth_headers).responseJSON { (response) in
                
                switch response.result{
                case .success(let jsonObject):
                    if let dic = jsonObject as? [String: Any] {
                        do {
                            let businessList = try MTLJSONAdapter.model(of: BusinessList.self, fromJSONDictionary: dic) as! BusinessList
                            businessList.page = page
                            
                            completion(businessList, "")
                            
                        } catch {
                            completion(nil, error.localizedDescription)
                        }
                    } else {
                        completion(nil, "")
                    }
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
            }
        } else {
            getConsumer { (success, message) in
                if success {
                    self.getBusinessList(coordinate: coordinate, completion: completion)
                } else {
                    completion(nil, "")
                }
            }
        }
    }

    func getBusinessList(from service: ServiceCategory, in coordinate: CLLocationCoordinate2D, page: Int = 1, completion: @escaping (_ businessList: BusinessList?, _ message: String) -> Void ) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			guard let session = SessionManager.sharedInstance.getCurrentSession() else {
				return
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			self.auth_headers.updateValue("Token token=\"\(session.authToken)\"", forKey: "X-Petbooking-Session-Token")
            
			let coords = "\(coordinate.latitude),\(coordinate.longitude)"
			
			let parameters: Parameters = ["user_id": session.userId,
                                          "coords": coords,
                                          "fields[businesses]": "id,name,slug,location,distance,street,street_number,imported,neighborhood,rating_average,rating_count,favorite_count,cover_image,pictures,transportation_fee,user_favorite,bitmask_values,phone,city,description,state,website,facebook_fanpage,twitter_profile,googleplus_profile,instagram,snapchat",
                                          "page[number]": page,
                                          "page[size]": 20]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/category-templates/\(service.id)/businesses", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: auth_headers).responseJSON { (response) in
				
				switch response.result {
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						do {
							let businessList = try MTLJSONAdapter.model(of: BusinessList.self, fromJSONDictionary: dic) as! BusinessList
							businessList.page = page
							
							completion(businessList, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					completion(nil, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.getBusinessList(coordinate: coordinate, service: service, completion: completion)
				} else {					
					completion(nil, "")
				}
			}
		}
	}
	
	func getBusinessListFiltered(text: String, locate: String, page: Int = 1, completion: @escaping (_ businessList: BusinessList?, _ message: String) -> Void ) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
            guard let session = SessionManager.sharedInstance.getCurrentSession() else { return }
            
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			self.auth_headers.updateValue("Token token=\"\(session.authToken)\"", forKey: "X-Petbooking-Session-Token")
			
            let parameters: Parameters = ["user_id": session.userId,
                                          "q": text,
                                          "location": locate,
                                          "fields[businesses]": "id,name,slug,location,distance,street,street_number,imported,neighborhood,rating_average,rating_count,favorite_count,cover_image,pictures,transportation_fee,user_favorite,bitmask_values,phone,city,description,state,website,facebook_fanpage,twitter_profile,googleplus_profile,instagram,snapchat",
                                          "page[number]": page,
                                          "page[size]": 20]

			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/businesses/search", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						do {
							let businessList = try MTLJSONAdapter.model(of: BusinessList.self, fromJSONDictionary: dic) as! BusinessList
							businessList.page = page
							
							completion(businessList, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					completion(nil, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.getBusinessListFiltered(text: text, locate: locate, completion: completion)
				} else {
					completion(nil, "")
				}
			}
		}
	}
	
	func removeBusinessFromFavorite(business:Business, completion: @escaping (_ success: Bool, _ message: String) -> Void ) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			guard let session = SessionManager.sharedInstance.getCurrentSession() else { return }
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			self.auth_headers.updateValue("Token token=\"\(session.authToken)\"", forKey: "X-Petbooking-Session-Token")
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/favorites/\(business.favoriteId)", method: .delete, parameters: nil, encoding: URLEncoding(destination: .queryString), headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let _ = jsonObject as? [String: Any] {
                        completion(true, "")
                    } else {
						completion(false, "")
					}
				case .failure(let error):
					completion(false, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.removeBusinessFromFavorite(business: business, completion: completion)
				} else {
					completion(false, "")
				}
			}
		}
	}

	func addBusinessToFavorite(business:Business, completion: @escaping (_ success: Bool, _ message: String) -> Void ) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			guard let session = SessionManager.sharedInstance.getCurrentSession() else {
				return
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			self.auth_headers.updateValue("Token token=\"\(session.authToken)\"", forKey: "X-Petbooking-Session-Token")
			
			let parameters: Parameters = ["data": ["type": "favorites",
                                                   "attributes": ["favorable_type": "Business",
                                                                  "favorable_id": business.id]]
			]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/\(session.userId)/favorites", method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {

							
							let favorite = try MTLJSONAdapter.model(of: Favorite.self, fromJSONDictionary: dic) as! Favorite
							business.favoriteId = favorite.favoriteId
							
							completion(true, "")
							
						} catch {
							completion(false, error.localizedDescription)
						}
					} else {
						completion(false, "")
					}
				case .failure(let error):
					completion(false, error.localizedDescription)
				}
				
			}
		} else
		{
			getConsumer(completion: { (success, message) in
				
				if success {
					self.addBusinessToFavorite(business: business, completion: completion)
				} else {
					
					completion(false, "")
					
				}
				
			})
		}
	}

	func getFavoriteBusinessList(page:Int = 1, completion: @escaping (_ businessList: BusinessList?, _ message: String) -> Void ) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			guard let session = SessionManager.sharedInstance.getCurrentSession() else {
				return
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			self.auth_headers.updateValue("Token token=\"\(session.authToken)\"", forKey: "X-Petbooking-Session-Token")
			
			let parameters: Parameters = ["type":"businesses", "fields[businesses]":"id,name,slug,location,distance,street,street_number,imported,neighborhood,rating_average,rating_count,favorite_count,cover_image,pictures,transportation_fee,user_favorite,bitmask_values,phone,city,description,state,website,facebook_fanpage,twitter_profile,googleplus_profile,instagram,snapchat,reviews", "page[number]":page, "page[size]":20]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/\(session.userId)/favorites", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {
							let businessList = try MTLJSONAdapter.model(of: BusinessList.self, fromJSONDictionary: dic) as! BusinessList
							businessList.page = page
							
							completion(businessList, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
				}
				
			}
		} else
		{
			getConsumer(completion: { (success, message) in
				
				if success {
					self.getFavoriteBusinessList(page:page, completion: completion)
				} else {
					
					completion(nil, "")
					
				}
				
			})
		}
	}
	
	func getBusinessServicesCategoryList(business:Business, completion: @escaping (_ serviceList: ServiceCategoryList?, _ message: String) -> Void ) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			guard let session = SessionManager.sharedInstance.getCurrentSession() else {
				return
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			self.auth_headers.updateValue("Token token=\"\(session.authToken)\"", forKey: "X-Petbooking-Session-Token")
			
			let parameters: Parameters = ["type":"service_categories", "fields[service_categories]":"name,service_count,slug,services,category_template_id"]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/businesses/\(business.id)/service-categories", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {
							let serviceList = try MTLJSONAdapter.model(of: ServiceCategoryList.self, fromJSONDictionary: dic) as! ServiceCategoryList
							
							completion(serviceList, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
				}
				
			}
		} else
		{
			getConsumer(completion: { (success, message) in
				
				if success {
					self.getBusinessServicesCategoryList(business:business, completion: completion)
				} else {
					
					completion(nil, "")
					
				}
				
			})
		}
	}
	
	func getBusinessServicesList(business: Business, service: ServiceCategory, pet: Pet?, completion: @escaping (_ serviceList: ServiceList?, _ message: String) -> Void ) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			guard let session = SessionManager.sharedInstance.getCurrentSession() else {
				return
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			self.auth_headers.updateValue("Token token=\"\(session.authToken)\"", forKey: "X-Petbooking-Session-Token")
			
			var parameters: Parameters = ["type": "services",
                                          "fields[services]": "name,duration,price,childs"]
            
            if let petId = pet?.id {
                parameters.updateValue(petId, forKey: "pet_id")
            }
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/service-categories/\(service.id)/services",
                method: .get,
                parameters: parameters,
                encoding: URLEncoding(destination: .queryString),
                headers: auth_headers).responseJSON { (response) in
				
				switch response.result {
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						do {
							let serviceList = try MTLJSONAdapter.model(of: ServiceList.self, fromJSONDictionary: dic) as! ServiceList
							
							completion(serviceList, "")
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					completion(nil, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.getBusinessServicesList(business:business,
                                                 service: service,
                                                 pet: pet,
                                                 completion: completion)
				} else {
					completion(nil, "")
				}
			}
		}
	}
	
	func getProfessionalsList(service: Service, completion: @escaping (_ professionalList: ProfessionalList?, _ message: String) -> Void ) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			guard let session = SessionManager.sharedInstance.getCurrentSession() else {
				return
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			self.auth_headers.updateValue("Token token=\"\(session.authToken)\"", forKey: "X-Petbooking-Session-Token")
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/services/\(service.id)/employments", method: .get, parameters: nil, encoding: URLEncoding(destination: .queryString), headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {
							let professionalList = try MTLJSONAdapter.model(of: ProfessionalList.self, fromJSONDictionary: dic) as! ProfessionalList
							
							completion(professionalList, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
				}
				
			}
		} else
		{
			getConsumer(completion: { (success, message) in
				
				if success {
					self.getProfessionalsList(service: service, completion: completion)
				} else {
					
					completion(nil, "")
					
				}
				
			})
		}
	}
	
	func createShoppingCart(itens: [Dictionary<String, Any>], completion: @escaping (_ cart: Cart?, _ message: String) -> Void) {
		
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
				"data": ["type":"carts", "attributes":["items":itens]]
			]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/\(userId)/carts", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					
					if let dic = jsonObject as? [String: Any] {
						
						do {
							
							let cart = try MTLJSONAdapter.model(of: Cart.self, fromJSONDictionary: dic) as! Cart
							
							
							completion(cart, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
				}
				
			}
		} else
		{
			getConsumer(completion: { (success, message) in
				
				if success {
					self.createShoppingCart(itens:itens,completion: completion)
				} else {
					
					completion(nil, "")
					
				}
			})
		}
	}
	
	func getBusinessReviews(business:Business, completion: @escaping (_ serviceList: ReviewList?, _ message: String) -> Void ) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
			var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			guard let session = SessionManager.sharedInstance.getCurrentSession() else {
				return
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			self.auth_headers.updateValue("Token token=\"\(session.authToken)\"", forKey: "X-Petbooking-Session-Token")
			
			let parameters: Parameters = ["type":"reviews", "fields[reviews]":"id,comment,business_rating,business_id,user_id"]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/businesses/\(business.id)/reviews", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {
							let serviceList = try MTLJSONAdapter.model(of: ReviewList.self, fromJSONDictionary: dic) as! ReviewList
							
							completion(serviceList, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
				}
				
			}
		} else
		{
			getConsumer(completion: { (success, message) in
				
				if success {
					self.getBusinessReviews(business:business, completion: completion)
				} else {
					
					completion(nil, "")
					
				}
				
			})
		}
	}
	
	func getScheduleList(page:Int = 1, completion: @escaping (_ businessList: ScheduledServiceList?, _ message: String) -> Void ) {
		
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
						
			let today = Date()
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"
			
			let todayString = dateFormatter.string(from: today)
			
			let parameters: Parameters = ["date": todayString, "page[number]": page, "page[size]": 200]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/\(userId)/schedules", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {
							let scheduledServiceList = try MTLJSONAdapter.model(of: ScheduledServiceList.self, fromJSONDictionary: dic) as! ScheduledServiceList
							scheduledServiceList.page = page
							
							completion(scheduledServiceList, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
				}
				
			}
		} else
		{
			getConsumer(completion: { (success, message) in
				
				if success {
					self.getScheduleList(page: page, completion: completion)
				} else {
					
					completion(nil, "")
					
				}
				
			})
		}
	}
	
	func cancelScheduledService(scheduledService:ScheduledService, completion: @escaping (_ businessList: ScheduledServiceList?, _ message: String) -> Void ) {
		
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
			
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/users/\(userId)/events/\(scheduledService.id)", method: .delete, parameters: nil, encoding: URLEncoding(destination: .queryString), headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						
						do {
							let scheduledServiceList = try MTLJSONAdapter.model(of: ScheduledServiceList.self, fromJSONDictionary: dic) as! ScheduledServiceList
							
							completion(scheduledServiceList, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					print(error)
					completion(nil, error.localizedDescription)
				}
				
			}
		} else
		{
			getConsumer(completion: { (success, message) in
				
				if success {
					self.cancelScheduledService(scheduledService: scheduledService, completion: completion)
				} else {
					completion(nil, "")
					
				}
				
			})
		}
	}
	
	func getCategoryList( completion: @escaping (_ serviceList: ServiceCategoryList?, _ message: String) -> Void ) {
		
		if SessionManager.sharedInstance.isConsumerValid() {
            guard let session = SessionManager.sharedInstance.getCurrentSession() else { return }
        
            var token = ""
			if let consumer = SessionManager.sharedInstance.getCurrentConsumer() {
				token = consumer.token
			}
			
			self.auth_headers.updateValue("Bearer \(token)", forKey: "Authorization")
			self.auth_headers.updateValue("Token token=\"\(session.authToken)\"", forKey: "X-Petbooking-Session-Token")
			
			let parameters: Parameters = ["type": "category_templates",
                                          "fields[category_templates]": "id,slug,name"]
			
			Alamofire.request("\(PetbookingAPI.API_BASE_URL)/category-templates",
                method: .get,
                parameters: parameters,
                encoding: URLEncoding(destination: .queryString),
                headers: auth_headers).responseJSON { (response) in
				
				switch response.result{
				case .success(let jsonObject):
					if let dic = jsonObject as? [String: Any] {
						do {
							let serviceList = try MTLJSONAdapter.model(of: ServiceCategoryList.self, fromJSONDictionary: dic) as! ServiceCategoryList
							completion(serviceList, "")
							
						} catch {
							completion(nil, error.localizedDescription)
						}
					} else {
						completion(nil, "")
					}
				case .failure(let error):
					completion(nil, error.localizedDescription)
				}
			}
		} else {
			getConsumer { (success, message) in
				if success {
					self.getCategoryList(completion: completion)
				} else {
					completion(nil, "")
				}
			}
		}
	}
}
