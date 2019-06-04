//
//  CategoryContentViewControllerRouter.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 08/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class CategoryContentRouter: CategoryContentWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(with banner: Banner) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = CategoryContentViewController(nibName: nil, bundle: nil)
        view.banner = banner
        let interactor = CategoryContentInteractor()
        let router = CategoryContentRouter()
        let presenter = CategoryContentPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    static func createModule(with service: ServiceCategory) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = CategoryContentViewController(nibName: nil, bundle: nil)
        view.service = service
        let interactor = CategoryContentInteractor()
        let router = CategoryContentRouter()
        let presenter = CategoryContentPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}

