//
//  NotificationsProtocols.swift
//  petbooking-ios-v2
//
//  Created by Enrique Melgarejo on 01/09/18.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

//MARK: Wireframe -
protocol NotificationsWireframeProtocol: class {
}
//MARK: Presenter -
protocol NotificationsPresenterProtocol: class {
}

//MARK: Interactor -
protocol NotificationsInteractorProtocol: class {

  var presenter: NotificationsPresenterProtocol?  { get set }
}

//MARK: View -
protocol NotificationsViewProtocol: class {

  var presenter: NotificationsPresenterProtocol?  { get set }
}
