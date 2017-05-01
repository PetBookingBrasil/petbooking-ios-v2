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
		
		Alamofire.request("https://novo.petbooking.com.br/api/v2/consumers/auth/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: consumer_headers).responseJSON { (response) in
			
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
						
						try SessionManager.sharedInstance.saveSession(session: session)
						
						completion(true, "")
						
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
	
}

// MARK: User

extension PetbookingAPI {
	
	func userInfo(_ completion: @escaping (_ user: User?, _ message: String) -> Void) {
		
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
		
		self.auth_headers["Authorization"] = "Bearer \(token)"
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
		
	}
	
}
