//
//  ScheduleCalendarPresenter.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 29/07/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class ScheduleCalendarPresenter: ScheduleCalendarPresenterProtocol {

    weak private var view: ScheduleCalendarViewProtocol?
    var interactor: ScheduleCalendarInteractorProtocol?
    private let router: ScheduleCalendarWireframeProtocol

    init(interface: ScheduleCalendarViewProtocol, interactor: ScheduleCalendarInteractorProtocol?, router: ScheduleCalendarWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}