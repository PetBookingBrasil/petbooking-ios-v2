//
//  LoginRouter.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 28/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class LoginRouter: LoginWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = LoginViewController(nibName: nil, bundle: nil)
        let interactor = LoginInteractor()
        let router = LoginRouter()
        let presenter = LoginPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
	

	func didTapSignupButton() {
		viewController?.navigationController?.pushViewController(SignupRouter.createModule(), animated: true)
	}
	
	func didTapForgotPasswordButton() {
		viewController?.navigationController?.pushViewController(ForgotPasswordRouter.createModule(), animated: true)
	}
	
	func didCompleteFacebookLoginWithSuccess() {
		
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let viewController = storyboard.instantiateViewController(withIdentifier :"ViewController")
			
			self.viewController?.present(viewController, animated: true, completion: nil)
		
	}
	
	func registerNewUserWithFacebookData() {
		viewController?.navigationController?.pushViewController(SignupRouter.createModule(signupType: .facebook), animated: true)
	}
}
