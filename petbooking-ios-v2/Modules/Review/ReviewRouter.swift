//
//  ReviewRouter.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 20/04/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class ReviewRouter: ReviewWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = ReviewViewController(nibName: nil, bundle: nil)
        let interactor = ReviewInteractor()
        let router = ReviewRouter()
        let presenter = ReviewPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
