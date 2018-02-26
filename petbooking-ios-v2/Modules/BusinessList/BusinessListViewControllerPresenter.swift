//
//  BusinessListViewControllerPresenter.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 20/06/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import  CoreLocation

class BusinessListViewControllerPresenter: BusinessListViewControllerPresenterProtocol, BusinessListViewControllerInteractorOutputProtocol {

	weak private var view: BusinessListViewControllerViewProtocol?
    private let router: BusinessListViewControllerWireframeProtocol
    
	var interactor: BusinessListViewControllerInteractorInputProtocol?
    var service: ServiceCategory?
	
	init(interface: BusinessListViewControllerViewProtocol, interactor: BusinessListViewControllerInteractorInputProtocol?, router: BusinessListViewControllerWireframeProtocol) {
		self.view = interface
		self.interactor = interactor
		self.router = router
	}
	
	func getBusinessByCoordinates(coordinates: CLLocationCoordinate2D, service: ServiceCategory?, page: Int) {
		interactor?.getBusinessByCoordinates(coordinates: coordinates, service: service, page: page)
	}
	
	func getFavoriteBusiness(page: Int) {
		interactor?.getFavoriteBusiness(page: page)
	}
	
	func updateBusinessList(businessList: BusinessList) {
		view?.updateBusinessList(businessList: businessList)
	}
	
	func addToFavorites(business: Business) {
		interactor?.addToFavorites(business: business)
	}
	
	func showBusinessPage(business: Business) {
		router.showBusinessPage(business, from: self.service)
	}
	
	func removedFromFavorites(business: Business) {
		view?.removedFromFavorites(business: business)
	}
}
