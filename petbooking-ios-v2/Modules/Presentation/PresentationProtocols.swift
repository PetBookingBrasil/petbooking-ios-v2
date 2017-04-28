//
//  PresentationProtocols.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 26/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//

import Foundation
import UIKit

//MARK: Wireframe -
protocol PresentationWireframeProtocol: class {
	
	func nextView(index:PresentationIndex)
	
	func skipPresentationView()

}
//MARK: Presenter -
protocol PresentationPresenterProtocol: class {
	
	func didTapNextButton()
	
	func didTapSkipButton()
	
	func nextView(index: PresentationIndex)
	
	func skipPresentationView()
	
	func setupView()
	
	func setupView(imageNamed:String, backgroundColorHexString:String, title:String, titleFont: UIFont?, description:String, descriptionFont: UIFont?)

}

//MARK: Interactor -
protocol PresentationInteractorProtocol: class {

  var presenter: PresentationPresenterProtocol?  { get set }
	
	func didTapNextButton()
	
	func didTapSkipButton()
	
	func setupView()
	
}

//MARK: View -
protocol PresentationViewProtocol: class {

  var presenter: PresentationPresenterProtocol?  { get set }
	
	func setupLogoImageView(imageNamed:String)
	
	func setupViewBackgroundColor(backgroundColorHexString:String)
	
	func setupLabels(title:String, titleFont:UIFont?, description:String, descriptionFont:UIFont?)
	
}
