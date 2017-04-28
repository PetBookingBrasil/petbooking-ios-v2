//
//  LoginProtocols.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 28/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol LoginWireframeProtocol: class {

}
//MARK: Presenter -
protocol LoginPresenterProtocol: class {
	
	func didTapLoginButton()
	
	func didTapFacebookLoginButton()
	
	func didTapSignupButton()
	
	func didTapForgotPasswordButton()

}

//MARK: Interactor -
protocol LoginInteractorProtocol: class {

  var presenter: LoginPresenterProtocol?  { get set }
}

//MARK: View -
protocol LoginViewProtocol: class {

  var presenter: LoginPresenterProtocol?  { get set }
}
