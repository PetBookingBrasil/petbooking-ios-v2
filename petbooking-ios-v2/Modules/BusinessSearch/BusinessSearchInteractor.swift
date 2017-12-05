//
//  BusinessSearchInteractor.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 11/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class BusinessSearchInteractor: BusinessSearchInteractorProtocol {

    weak var presenter: BusinessSearchPresenterProtocol?
	
	func addToFavorites(business: Business) {
		
		if business.isFavorited() {
			
			PetbookingAPI.sharedInstance.removeBusinessFromFavorite(business: business, completion: { (success, message) in
				
				if success {
					self.presenter?.removedFromFavorites(business: business)
					business.favoriteId = 0
				}
				
			})
			
		} else {
			
			PetbookingAPI.sharedInstance.addBusinessToFavorite(business: business) { (success, message) in
				
				if success {
					//business.isFavorite = true
				}
				
			}
		}
		
	}
}
