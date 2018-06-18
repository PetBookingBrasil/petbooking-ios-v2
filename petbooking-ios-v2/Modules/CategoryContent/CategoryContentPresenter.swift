//
//  CategoryContentViewControllerPresenter.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 08/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class CategoryContentPresenter: CategoryContentPresenterProtocol {
    
    weak private var view: CategoryContentViewProtocol?
    private let interactor: CategoryContentInteractorProtocol
    private let router: CategoryContentWireframeProtocol
    
    init(interface: CategoryContentViewProtocol,
         interactor: CategoryContentInteractorProtocol,
         router: CategoryContentWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
        
        self.interactor.presenter = self
    }
}

