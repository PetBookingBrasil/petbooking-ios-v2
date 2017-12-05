//
//  BusinessSearchProtocols.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 11/08/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol BusinessSearchWireframeProtocol: class {

	func showBusinessPage(business:Business)
}
//MARK: Presenter -
protocol BusinessSearchPresenterProtocol: class {

	func showBusinessPage(business:Business)
	
	func removedFromFavorites(business: Business)
	
	func addToFavorites(business: Business)
}

//MARK: Interactor -
protocol BusinessSearchInteractorProtocol: class {

  var presenter: BusinessSearchPresenterProtocol?  { get set }
	
	func addToFavorites(business: Business)
	
}

//MARK: View -
protocol BusinessSearchViewProtocol: class {

  var presenter: BusinessSearchPresenterProtocol?  { get set }
	
}