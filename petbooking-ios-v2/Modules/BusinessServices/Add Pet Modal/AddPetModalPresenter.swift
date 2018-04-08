//
//  AddPetModalPresenter.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 07/04/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation
import ALLoadingView

class AddPetModelPresenter: AddPetModelPresenterProtocol {
    
    weak private var view: AddPetModelViewProtocol?
    private let interactor: AddPetModelInteractorProtocol
    private let router: AddPetModelWireframeProtocol
    
    init(interface: AddPetModelViewProtocol, interactor: AddPetModelInteractorProtocol, router: AddPetModelWireframeProtocol) {
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
    
    func didSavePetWithError(message:String) {
        ALLoadingView.manager.hideLoadingView()
        view?.showAlertMessage(title: "", message: message)
    }
}
