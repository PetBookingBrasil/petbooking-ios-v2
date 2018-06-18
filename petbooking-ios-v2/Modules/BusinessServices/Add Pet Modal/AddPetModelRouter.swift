//
//  AddPetModelRouter.swift
//  petbooking-ios-v2
//
//  Created by David Batista on 07/04/2018.
//  Copyright © 2018 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class AddPetModelRouter: AddPetModelWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    var delegate: AddPetModalDelegate?
    
    static func createModule(pet: Pet = Pet(), petViewType: PetViewType = .create, delegate: AddPetModalDelegate) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = AddPetModalViewController(nibName: nil, bundle: nil)
        view.pet = pet
        view.petViewType = petViewType
        let interactor = AddPetModalInteractor()
        interactor.petViewType = petViewType
        let router = AddPetModelRouter()
        let presenter = AddPetModelPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        router.delegate = delegate
        
        return view
    }
    
    func didSavePetWithSuccess() {
        delegate?.savePet()
        viewController?.dismiss(animated: true, completion: nil)
    }
    
}
