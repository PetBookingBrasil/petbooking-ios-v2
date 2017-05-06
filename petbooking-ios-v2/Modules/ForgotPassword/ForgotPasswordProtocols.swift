//
//  ForgotPasswordProtocols.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 29/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol ForgotPasswordWireframeProtocol: class {

}
//MARK: Presenter -
protocol ForgotPasswordPresenterProtocol: class {
	
	func didTapSendButton(email:String)

}

//MARK: Interactor -
protocol ForgotPasswordInteractorProtocol: class {

  var presenter: ForgotPasswordPresenterProtocol?  { get set }
	
	func didTapSendButton(email:String)
}

//MARK: View -
protocol ForgotPasswordViewProtocol: class {

  var presenter: ForgotPasswordPresenterProtocol?  { get set }
}
