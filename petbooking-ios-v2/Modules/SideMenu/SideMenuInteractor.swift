//
//  SideMenuInteractor.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 18/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

enum SideMenuItem {
    case myPets
    case search
    case schedule
    case payments
    case favorites
    case settings
    case logout
}

class SideMenuInteractor: SideMenuInteractorProtocol {
    
    weak var presenter: SideMenuPresenterProtocol?
    
    func didTapLogout() {
        UserManager.sharedInstance.logOut()
    }
}
