//
//  PresentationRouter.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 26/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//

import UIKit

class PresentationRouter: PresentationWireframeProtocol {
	
	weak var navigationController: UINavigationController?
	weak var viewController: UIViewController?
	
	
	
	static func createFirstModule() -> UINavigationController {
		// Change to get view from storyboard if not using progammatic UI
		
		let navigationController = UINavigationController()
		let view = PresentationRouter.createModule(index: .first, navigationController: navigationController)
		navigationController.setViewControllers([view], animated: false)
		
		
		return navigationController
	}
	
	
	static func createModule(index:PresentationIndex, navigationController:UINavigationController? = nil) -> UIViewController {
		// Change to get view from storyboard if not using progammatic UI
		let view = PresentationViewController(nibName: nil, bundle: nil)
		let interactor = PresentationInteractor()
		let router = PresentationRouter()
		let presenter = PresentationPresenter(interface: view, interactor: interactor, router: router)
		
		interactor.index = index
		view.presenter = presenter
		interactor.presenter = presenter
		router.viewController = view
		router.navigationController = navigationController
		
		return view
	}
	
	func nextView(index:PresentationIndex) {
		
		self.viewController?.navigationController?.pushViewController(PresentationRouter.createModule(index: index), animated: true)
	}
	
	func skipPresentationView() {
		
		self.viewController?.present(LoginRouter.createModule(), animated: true, completion: nil)
	}
}
