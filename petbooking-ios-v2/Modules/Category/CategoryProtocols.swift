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
}

//MARK: Presenter -
protocol CategoryPresenterProtocol: class {
    func showCategoryContent(from service: ServiceCategory)
}

//MARK: Interactor -
protocol CategoryInteractorProtocol: class {
    var presenter: CategoryPresenterProtocol?  { get set }    
}

//MARK: View -
protocol CategoryViewProtocol: class {
    var presenter: CategoryPresenterProtocol?  { get set }
}

