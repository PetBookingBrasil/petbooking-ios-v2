//
//  BusinessListViewControllerInteractor.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 20/06/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import CoreLocation

enum BusinessListType {
    case list, map, favorites
}

class BusinessListViewControllerInteractor: BusinessListViewControllerInteractorInputProtocol {
	
	weak var presenter: BusinessListViewControllerInteractorOutputProtocol?
	
	var businessListType:BusinessListType?
	
    func getBusinessByCoordinates(coordinates: CLLocationCoordinate2D, service: ServiceCategory?, page: Int) {
		
        PetbookingAPI.sharedInstance.getBusinessList(coordinate: coordinates, service: service, page:page) { (businessList, msg) in
			
			guard let businessList = businessList else {
				return
			}
			
			self.presenter?.updateBusinessList(businessList: businessList)
		}		
	}
	
	func getFavoriteBusiness(page: Int) {
		
		PetbookingAPI.sharedInstance.getFavoriteBusinessList(page:page) { (businessList, msg) in
			guard let businessList = businessList else {
				return
			}
			
			self.presenter?.updateBusinessList(businessList: businessList)
		}
	}
	
	func addToFavorites(business: Business) {
		
		if business.isFavorited() {
			PetbookingAPI.sharedInstance.removeBusinessFromFavorite(business: business) { (success, message) in
				if success {
					self.presenter?.removedFromFavorites(business: business)
					business.favoriteId = 0
				}
			}
		} else {
			PetbookingAPI.sharedInstance.addBusinessToFavorite(business: business) { (success, message) in
				if success {
                    business.favoriteId = 1
				}
			}
		}
	}
}
