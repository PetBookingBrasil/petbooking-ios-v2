//
//  WebviewRouter.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 10/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class WebviewRouter: WebviewWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(from webviewRequest: WebviewRequest) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = WebviewViewController(nibName: nil, bundle: nil)
        view.webviewRequest = webviewRequest
        let interactor = WebviewInteractor()
        let router = WebviewRouter()
        let presenter = WebviewPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
