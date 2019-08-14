//
//  CategoryProtocols.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 07/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

//MARK: Wireframe -
protocol CategoryWireframeProtocol: class {
    func showCategoryContent(from service: ServiceCategory)
    func showBannerContent(from banner: Banner)
}

//MARK: Presenter -
protocol CategoryPresenterProtocol: class {
    func getReview()
    func loadReview(reviewList: ReviewableList)
    func showCategoryContent(from service: ServiceCategory)
    func showBannerContent(from banner: Banner)
}

//MARK: Interactor -
protocol CategoryInteractorProtocol: class {
    var presenter: CategoryPresenterProtocol?  { get set }
    
    func getReview()
}

//MARK: View -
protocol CategoryViewProtocol: class {
    var presenter: CategoryPresenterProtocol?  { get set }
    
    func showReviewable(_ review: ReviewableList)
}

