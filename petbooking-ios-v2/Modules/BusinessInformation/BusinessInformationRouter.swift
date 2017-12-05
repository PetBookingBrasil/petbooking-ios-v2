//
//  BusinessInformationRouter.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 03/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class BusinessInformationRouter: BusinessInformationWireframeProtocol {
    
    weak var viewController: UIViewController?
    
	static func createModule(business:Business) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = BusinessInformationViewController(nibName: nil, bundle: nil)
				view.business = business
        let interactor = BusinessInformationInteractor()
        let router = BusinessInformationRouter()
        let presenter = BusinessInformationPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}