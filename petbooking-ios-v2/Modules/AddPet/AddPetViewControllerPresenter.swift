//
//  AddPetViewControllerPresenter.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 25/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import ALLoadingView

class AddPetViewControllerPresenter: AddPetViewControllerPresenterProtocol {

    weak private var view: AddPetViewControllerViewProtocol?
    private let interactor: AddPetViewControllerInteractorProtocol
    private let router: AddPetViewControllerWireframeProtocol

    init(interface: AddPetViewControllerViewProtocol, interactor: AddPetViewControllerInteractorProtocol, router: AddPetViewControllerWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router

        self.interactor.presenter = self
    }

	func didtapSaveButton(pet:Pet) {
		ALLoadingView.manager.showLoadingView(ofType: .basic)
		interactor.savePet(pet: pet)
	}
	
	func didSavePetWithSuccess() {
		
		ALLoadingView.manager.hideLoadingView()
		router.didSavePetWithSuccess()
	}
}
