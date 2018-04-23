//
//  SettingsProtocols.swift
//  petbooking-ios-v2
//
//  Created David Batista on 08/04/18.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

//MARK: Wireframe -
protocol SettingsWireframeProtocol: class { }

//MARK: Presenter -
protocol SettingsPresenterProtocol: class { }

//MARK: Interactor -
protocol SettingsInteractorProtocol: class {
    var presenter: SettingsPresenterProtocol? { get set }
}

//MARK: View -
protocol SettingsViewProtocol: class {
    var presenter: SettingsPresenterProtocol? { get set }
}
