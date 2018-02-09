//
//  BusinessSearchRouter.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 11/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class BusinessSearchRouter: BusinessSearchWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = BusinessSearchViewController(nibName: nil, bundle: nil)
        let interactor = BusinessSearchInteractor()
        let router = BusinessSearchRouter()
        let presenter = BusinessSearchPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
	
	func showBusinessPage(business: Business) {		
		let homeBusiness = HomeBusinessRouter.createModule(business: business)
		
		self.viewController?.navigationController?.pushViewController(homeBusiness, animated: true)
	}
}
