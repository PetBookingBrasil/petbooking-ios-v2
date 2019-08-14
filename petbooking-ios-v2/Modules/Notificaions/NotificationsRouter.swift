//
//  NotificationsRouter.swift
//  petbooking-ios-v2
//
//  Created by Enrique Melgarejo on 01/09/18.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

class NotificationsRouter: NotificationsWireframeProtocol {

  weak var viewController: UIViewController?

  static func createModule() -> UIViewController {
    // Change to get view from storyboard if not using progammatic UI
    let view = NotificationsViewController(nibName: nil, bundle: nil)
    let interactor = NotificationsInteractor()
    let router = NotificationsRouter()
    let presenter = NotificationsPresenter(view: view, interactor: interactor, router: router)

    view.presenter = presenter
    interactor.presenter = presenter
    router.viewController = view

    return view
  }
}
