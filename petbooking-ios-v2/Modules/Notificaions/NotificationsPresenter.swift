//
//  NotificationsPresenter.swift
//  petbooking-ios-v2
//
//  Created by Enrique Melgarejo on 01/09/18.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

class NotificationsPresenter: NotificationsPresenterProtocol {

  private weak var view: NotificationsViewProtocol?
  private weak var interactor: NotificationsInteractorProtocol?
  private weak var router: NotificationsWireframeProtocol?

  init(view: NotificationsViewProtocol, interactor: NotificationsInteractorProtocol, router: NotificationsWireframeProtocol) {
    self.view = view
    self.interactor = interactor
    self.router = router
  }
  
}
