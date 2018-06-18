//
//  AddPetModalInteractor.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 07/04/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

class AddPetModalInteractor: AddPetModelInteractorProtocol {
    
    weak var presenter: AddPetModelPresenterProtocol?
    
    var petViewType: PetViewType?
    
    func savePet(pet: Pet) {
        PetbookingAPI.sharedInstance.createPet(pet: pet) { (pet, message) in
            if pet != nil {
                self.presenter?.didSavePetWithSuccess()
            } else {
                self.presenter?.didSavePetWithError(message: message)
            }
        }
    }
}
