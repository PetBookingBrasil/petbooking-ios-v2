//
//  AgendaProtocols.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 08/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol AgendaWireframeProtocol: class { }

//MARK: Presenter -
protocol AgendaPresenterProtocol: class { }

//MARK: Interactor -
protocol AgendaInteractorProtocol: class {
  var presenter: AgendaPresenterProtocol?  { get set }
}

//MARK: View -
protocol AgendaViewProtocol: class {
  var presenter: AgendaPresenterProtocol?  { get set }
}
