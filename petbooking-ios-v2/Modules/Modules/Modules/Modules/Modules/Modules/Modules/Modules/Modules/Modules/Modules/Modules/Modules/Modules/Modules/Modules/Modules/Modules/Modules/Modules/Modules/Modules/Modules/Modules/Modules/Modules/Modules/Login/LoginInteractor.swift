//
//  LoginInteractor.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 28/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginInteractor: LoginInteractorProtocol {
	
	weak var presenter: LoginPresenterProtocol?
	
	func didTapLoginButton(email:String?, password:String?) {
		
		guard let email = email else {
			return
		}
		
		guard let password = password else {
			return
		}
		
		guard let consumer = SessionManager.sharedInstance.getCurrentConsumer() else {
			return
		}
		
		if consumer.isValid() {
			
			PetbookingAPI.sharedInstance.loginWithEmail(email, password: password) { (success, message) in
				
				if success {
					self.presenter?.didCompleteLoginWithSuccess()
				} else {
					self.presenter?.didCompleteLoginWithError(error: nil)
				}
				
			}
		} else {
			
			PetbookingAPI.sharedInstance.getConsumer { (success, message) in
				
				if success {
					PetbookingAPI.sharedInstance.loginWithEmail(email, password: password) { (success, message) in
						
						if success {
							self.presenter?.didCompleteLoginWithSuccess()
						} else {
							self.presenter?.didCompleteLoginWithError(error: nil)
						}
						
					}
				} else {
					self.presenter?.didCompleteLoginWithError(error: nil)
				}
				
			}
			
		}
		
	}
	
	func didTapFacebookLoginButton() {
		
		let loginManager = LoginManager()
		loginManager.logIn([.publicProfile, .email], viewController: nil) { (loginResult) in
			
			switch loginResult {
			case .failed(let error):
				self.presenter?.didCompleteFacebookLoginWithError(error: error)
				break
			case .cancelled:
				self.presenter?.didCompleteFacebookLoginWithError(error: nil)
				break
			case .success( _, _, let accessToken):
				
				self.presenter?.showLoading()
				
				if let _ = SessionManager.sharedInstance.getCurrentConsumer()?.isValid() {
					
					PetbookingAPI.sharedInstance.loginWithFacebook(accessToken.authenticationToken, completion: { (success, message) in
						
						if success {
							self.presenter?.didCompleteFacebookLoginWithSuccess()
						} else {
							self.presenter?.registerNewUserWithFacebookData()
						}
						
					})
				} else {
					PetbookingAPI.sharedInstance.getConsumer { (success, message) in
						
						if success {
							PetbookingAPI.sharedInstance.loginWithFacebook(accessToken.authenticationToken, completion: { (success, message) in
								
								if success {
									self.presenter?.didCompleteFacebookLoginWithSuccess()
								} else {
									self.presenter?.registerNewUserWithFacebookData()
								}
								
							})
						} else {
							self.presenter?.didCompleteFacebookLoginWithError(error: nil)
						}
					}
				}
				break
			}
			
		}
		
		
	}
	
	func didTapSignupButton() {
		
		
	}
	
	func didTapForgotPasswordButton() {
		
	}
}
