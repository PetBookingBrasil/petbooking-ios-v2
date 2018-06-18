//
//  CategoryRouter.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 07/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class CategoryRouter: CategoryWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {

        let view = CategoryViewController(nibName: nil, bundle: nil)
        let interactor = CategoryInteractor()
        let router = CategoryRouter()
        let presenter = CategoryPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func showCategoryContent(from service: ServiceCategory) {
        let categoryContent = CategoryContentRouter.createModule(with: service)
        
        self.viewController?.navigationController?.pushViewController(categoryContent, animated: true)
    }
}
