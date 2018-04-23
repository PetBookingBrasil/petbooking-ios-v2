//
//  SettingsRouter.swift
//  petbooking-ios-v2
//
//  Created David Batista on 08/04/18.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class SettingsRouter: SettingsWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = SettingsViewController(nibName: nil, bundle: nil)
        let interactor = SettingsInteractor()
        let router = SettingsRouter()
        let presenter = SettingsPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
