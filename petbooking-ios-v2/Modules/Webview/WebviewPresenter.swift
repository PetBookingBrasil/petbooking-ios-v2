//
//  WebviewPresenter.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 10/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

class WebviewPresenter: WebviewPresenterProtocol {
    
    weak private var view: WebviewViewProtocol?
    private let interactor: WebviewInteractorProtocol
    private let router: WebviewWireframeProtocol
    
    init(interface: WebviewViewProtocol,
         interactor: WebviewInteractorProtocol,
         router: WebviewWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
        
        self.interactor.presenter = self
    }
}
