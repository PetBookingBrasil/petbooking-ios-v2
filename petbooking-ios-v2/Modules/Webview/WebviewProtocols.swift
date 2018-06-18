
//
//  WeviewProtocols.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 10/02/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

//MARK: Wireframe -
protocol WebviewWireframeProtocol: class { }

//MARK: Presenter -
protocol WebviewPresenterProtocol: class { }

//MARK: Interactor -
protocol WebviewInteractorProtocol: class {
    var presenter: WebviewPresenterProtocol?  { get set }
}

//MARK: View -
protocol WebviewViewProtocol: class {
    var presenter: WebviewPresenterProtocol?  { get set }
}
