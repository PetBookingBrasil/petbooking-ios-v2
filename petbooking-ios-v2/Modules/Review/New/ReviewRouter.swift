//
//  ReviewRouter.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 07/04/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class ReviewRouter: ReviewWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(reviews: ReviewableList) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = ReviewViewController(nibName: nil, bundle: nil)
        let interactor = ReviewInteractor()
        let router = ReviewRouter()
        let presenter = ReviewPresenter(interface: view, interactor: interactor, router: router)
        
        view.reviewList = reviews
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }    
}
