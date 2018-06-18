//
//  AddPetModalProtocols.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 07/04/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

//MARK: Wireframe -
protocol AddPetModelWireframeProtocol: class {
    func didSavePetWithSuccess()
}

//MARK: Presenter -
protocol AddPetModelPresenterProtocol: class {
    func didtapSaveButton(pet: Pet)
    func didSavePetWithSuccess()
    func didSavePetWithError(message:String)
}

//MARK: Interactor -
protocol AddPetModelInteractorProtocol: class {
    var presenter: AddPetModelPresenterProtocol?  { get set }
    
    func savePet(pet:Pet)
}

//MARK: View -
protocol AddPetModelViewProtocol: class {
    var presenter: AddPetModelPresenterProtocol?  { get set }
    
    func showAlertMessage(title: String, message: String)
}
