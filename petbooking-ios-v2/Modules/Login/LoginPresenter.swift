//
//  LoginPresenter.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 28/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class LoginPresenter: LoginPresenterProtocol {

    weak private var view: LoginViewProtocol?
    private let interactor: LoginInteractorProtocol
    private let router: LoginWireframeProtocol

    init(interface: LoginViewProtocol, interactor: LoginInteractorProtocol, router: LoginWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router

        self.interactor.presenter = self
    }
	
	func didTapLoginButton(email:String?, password:String?) {
		
	}
	
	func didTapFacebookLoginButton() {
		interactor.didTapFacebookLoginButton()
	}
	
	func didTapSignupButton() {
		router.didTapSignupButton()
		
	}
	
	func didTapForgotPasswordButton() {
		
		router.didTapForgotPasswordButton()
	}
	
	func didCompleteFacebookLoginWithSuccess() {
		router.didCompleteFacebookLoginWithSuccess()
	}
	
	func didCompleteFacebookLoginWithError(error: Error) {
		
	}

}
