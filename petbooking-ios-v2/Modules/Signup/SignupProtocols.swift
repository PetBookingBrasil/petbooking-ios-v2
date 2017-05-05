//
//  SignupProtocols.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 29/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol SignupWireframeProtocol: class {

	func createUserWithSuccess()
}
//MARK: Presenter -
protocol SignupPresenterProtocol: class {

	func fillFields()
	
	func setProfileImageView(urlString:String)
		
	func setNameLabel(name:String)
	
	func setEmail(email:String)
	
	func fillAdrressWithZipcode(zipcode:String)
	
	func fillAdrressFields(street:String, neighborhood:String, city:String, state:String)
	
	func createUser(name:String, cpf:String, birthday:String, email:String, mobile:String, zipcode:String, street:String, streetNumber:String, neighborhood:String, city:String, state:String, password:String, avatar:String)
	
	func createUserWithSuccess()
	
	func createUserWithError()
}

//MARK: Interactor -
protocol SignupInteractorProtocol: class {

  var presenter: SignupPresenterProtocol?  { get set }
	
	func fillFields()
	
	func fillAdrressWithZipcode(zipcode:String)
	
	func createUser(name:String, cpf:String, birthday:String, email:String, mobile:String, zipcode:String, street:String, streetNumber:String, neighborhood:String, city:String, state:String, password:String, avatar:String)
	
}

//MARK: View -
protocol SignupViewProtocol: class {

  var presenter: SignupPresenterProtocol?  { get set }
	
	func setProfileImageView(urlString:String)
	
	func setNameLabel(name:String)
	
	func setEmail(email:String)
	
	func fillAdrressFields(street:String, neighborhood:String, city:String, state:String)
}
