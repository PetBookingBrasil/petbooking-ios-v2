//
//  ReviewPresenter.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 20/04/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

class ReviewPresenter: ReviewPresenterProtocol {
    
    weak private var view: ReviewViewProtocol?
    var interactor: ReviewInteractorProtocol?
    private let router: ReviewWireframeProtocol
    
    init(interface: ReviewViewProtocol, interactor: ReviewInteractorProtocol?, router: ReviewWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
}
