//
//  SignupInteractor.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 29/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import FacebookCore
import Mantle

class SignupInteractor: SignupInteractorProtocol {
	
	var signupType:SignupType?
	
	weak var presenter: SignupPresenterProtocol?
	
	func fillFields() {
		
		switch signupType! {
		case .facebook:
			let connection = GraphRequestConnection()
			connection.add(GraphRequest(graphPath: "/me", parameters:["fields": "id, name, email, picture"])) { httpResponse, result in
				switch result {
				case .success(let response):
					print("Graph Request Succeeded: \(response)")
					
					if let dic = response.dictionaryValue {
						do {
						let facebookGraph = try MTLJSONAdapter.model(of: FacebookGraphModel.self, fromJSONDictionary: dic) as! FacebookGraphModel
							
							self.presenter?.setProfileImageView(urlString: facebookGraph.profileUrl)
							self.presenter?.setNameLabel(name: facebookGraph.name)
							self.presenter?.setEmail(email: facebookGraph.email)
							
						} catch {
							
						}
					}
				case .failed(let error):
					print("Graph Request Failed: \(error)")
				}
			}
			connection.start()
			break
		case .email:
			break
		}
		
	}
	
	func fillAdrressWithZipcode(zipcode:String) {
		
		ViaCepAPI.sharedInstance.getAddressByZipcode(zipcode: zipcode) { (address, message) in
			
			guard let address = address else {
				return
			}
			self.presenter?.fillAdrressFields(street: address.street, neighborhood: address.neighborhood, city: address.city, state: address.state)
			
		}
	}
	
	func createUser(name:String, cpf:String, birthday:String, email:String, mobile:String, zipcode:String, street:String, streetNumber:String, neighborhood:String, city:String, state:String, password:String, avatar:String) {
		
		var provider = "b2beauty"
		var providerToken = ""
		if signupType == .facebook {
			if let token = AccessToken.current?.authenticationToken {
				provider = "facebook"
				providerToken = token
			}
		}
		
		PetbookingAPI.sharedInstance.createUser(name: name, cpf: cpf, birthday: birthday, email: email, mobile: mobile, zipcode: zipcode, street: street, streetNumber: streetNumber, neighborhood: neighborhood, city: city, state: state, password: password, provider: provider, providerToken: providerToken, avatar:avatar) { (success, message) in
			
			if success {
				 self.presenter?.createUserWithSuccess()
			} else {
				self.presenter?.createUserWithError()
			}
		}
	}
}

enum SignupType {
	case email, facebook
}