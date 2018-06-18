//
//  CategoryContentViewControllerProtocols.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 08/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

//MARK: Wireframe -
protocol CategoryContentWireframeProtocol: class { }

//MARK: Presenter -
protocol CategoryContentPresenterProtocol: class { }

//MARK: Interactor -
protocol CategoryContentInteractorProtocol: class {
    var presenter: CategoryContentPresenterProtocol?  { get set }
}

//MARK: View -
protocol CategoryContentViewProtocol: class {
    var presenter: CategoryContentPresenterProtocol?  { get set }
}

