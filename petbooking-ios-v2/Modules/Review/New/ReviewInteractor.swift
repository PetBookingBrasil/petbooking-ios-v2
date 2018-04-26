//
//  ReviewInteractor.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 07/04/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import Foundation

class ReviewInteractor: ReviewInteractorProtocol {
    
    weak var presenter: ReviewPresenterProtocol?
    
    func loadPet(_ petId: Int) {
        
        PetbookingAPI.sharedInstance.getUserPet(petId: petId) { (pet, message) in
            guard let pet = pet else { return }
            
            self.presenter?.show(pet: pet)
        }
        
    }
    
}
