//
//  MyPetsPresenter.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 20/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class MyPetsPresenter: MyPetsPresenterProtocol {

    weak private var view: MyPetsViewProtocol?
    private let interactor: MyPetsInteractorProtocol
    private let router: MyPetsWireframeProtocol

    init(interface: MyPetsViewProtocol, interactor: MyPetsInteractorProtocol, router: MyPetsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router

        self.interactor.presenter = self
    }
	
	func reloadTableData() {
		
		interactor.reloadTableData()
	}
	
	func fillTableData(petList: PetList) {
		view?.fillTableData(petList: petList)
	}

}
