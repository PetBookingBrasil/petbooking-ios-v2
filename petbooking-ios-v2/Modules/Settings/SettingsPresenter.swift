//
//  SettingsPresenter.swift
//  petbooking-ios-v2
//
//  Created David Batista on 08/04/18.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//

import UIKit

class SettingsPresenter: SettingsPresenterProtocol {

    weak private var view: SettingsViewProtocol?
    var interactor: SettingsInteractorProtocol?
    private let router: SettingsWireframeProtocol

    init(interface: SettingsViewProtocol, interactor: SettingsInteractorProtocol?, router: SettingsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
