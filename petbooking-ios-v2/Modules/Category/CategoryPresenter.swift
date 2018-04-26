//
//  CategoryPresenter.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 07/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class CategoryPresenter: CategoryPresenterProtocol {
    
    weak private var view: CategoryViewProtocol?
    var interactor: CategoryInteractorProtocol?
    private let router: CategoryWireframeProtocol
    
    init(interface: CategoryViewProtocol, interactor: CategoryInteractorProtocol?, router: CategoryWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func showCategoryContent(from service: ServiceCategory) {
        router.showCategoryContent(from: service)
    }
    
    func getReview() {
        interactor?.getReview()
    }
    
    func loadReview(reviewList: ReviewableList) {
        DispatchQueue.main.async {
            self.view?.showReviewable(reviewList)
        }
    }
}

