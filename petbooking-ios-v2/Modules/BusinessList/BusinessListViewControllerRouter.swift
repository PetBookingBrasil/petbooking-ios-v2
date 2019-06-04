//
//  BusinessListViewControllerRouter.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 20/06/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class BusinessListViewControllerRouter: BusinessListViewControllerWireframeProtocol {
    
	weak var viewController: UIViewController?
	
    static func createModule(businessListType: BusinessListType, withBanner banner: Banner? = nil, from service: ServiceCategory? = nil) -> UIViewController {
		// Change to get view from storyboard if not using progammatic UI
        
        var view: BusinessListViewControllerViewProtocol!
        
        switch businessListType {
        case .list, .favorites:
            view = BusinessListViewController(nibName: nil, bundle: nil)
        default:
            view = BusinessMapListViewController(nibName: nil, bundle: nil)
        }
        
        view.banner = banner
        view.service = service
		view.businessListType = businessListType
		
		let interactor = BusinessListViewControllerInteractor()
		interactor.businessListType = businessListType
		let router = BusinessListViewControllerRouter()
		let presenter = BusinessListViewControllerPresenter(interface: view, interactor: interactor, router: router)
		
		view.presenter = presenter
        presenter.service = service
        
		interactor.presenter = presenter
		router.viewController = view as? UIViewController
		
		return view as! UIViewController
	}
    
    func showBusinessPage(_ business: Business, from service: ServiceCategory?) {
		let homeBusiness = HomeBusinessRouter.createModule(with: business, from: service)
		
		self.viewController?.navigationController?.pushViewController(homeBusiness, animated: true)
	}
}
