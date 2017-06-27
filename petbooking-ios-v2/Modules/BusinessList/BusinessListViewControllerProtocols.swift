//
//  BusinessListViewControllerProtocols.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 20/06/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation
import CoreLocation

//MARK: Wireframe -
protocol BusinessListViewControllerWireframeProtocol: class {
	
}
//MARK: Presenter -
protocol BusinessListViewControllerPresenterProtocol: class {
	
	var interactor: BusinessListViewControllerInteractorInputProtocol? { get set }
	
	func getBusinessByCoordinates(coordinates:CLLocationCoordinate2D, page:Int)
}

//MARK: Interactor -
protocol BusinessListViewControllerInteractorOutputProtocol: class {
	
	/* Interactor -> Presenter */
	
	func updateBusinessList(businessList:BusinessList)
	
}

protocol BusinessListViewControllerInteractorInputProtocol: class {
	
	var presenter: BusinessListViewControllerInteractorOutputProtocol?  { get set }
	
	func getBusinessByCoordinates(coordinates:CLLocationCoordinate2D, page:Int)
	
	/* Presenter -> Interactor */
}

//MARK: View -
protocol BusinessListViewControllerViewProtocol: class {
	
	var presenter: BusinessListViewControllerPresenterProtocol?  { get set }
	
	func updateBusinessList(businessList:BusinessList)
	
	/* Presenter -> ViewController */
}
