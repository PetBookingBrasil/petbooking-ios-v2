//
//  SideMenuProtocols.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 18/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol SideMenuWireframeProtocol: class {
	
	func didTapLogout()
	
	func didTapMyPets()
	
	func showProfile()

}
//MARK: Presenter -
protocol SideMenuPresenterProtocol: class {
	
	func didTapLogout()
	
	func didTapMyPets()
	
	func didTapProfile()

}

//MARK: Interactor -
protocol SideMenuInteractorProtocol: class {

  var presenter: SideMenuPresenterProtocol?  { get set }
	
	func didTapLogout()
	
}

//MARK: View -
protocol SideMenuViewProtocol: class {

  var presenter: SideMenuPresenterProtocol?  { get set }
}
