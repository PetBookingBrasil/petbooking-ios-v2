//
//  PresentationPresenter.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 26/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//

import UIKit

class PresentationPresenter: PresentationPresenterProtocol {

    weak private var view: PresentationViewProtocol?
    private let interactor: PresentationInteractorProtocol
    private let router: PresentationWireframeProtocol

    init(interface: PresentationViewProtocol, interactor: PresentationInteractorProtocol, router: PresentationWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router

        self.interactor.presenter = self
    }
	
	func didTapNextButton() {
		interactor.didTapNextButton()
	}
	
	func didTapSkipButton() {
		interactor.didTapSkipButton()
	}
	
	func nextView(index: PresentationIndex) {
		router.nextView(index: index)
	}
	
	func skipPresentationView() {
		router.skipPresentationView()
	}
	
	func setupView() {
		
		interactor.setupView()
		
	}
	
	func setupView(imageNamed:String, backgroundColorHexString:String, title:String, description:String) {
		
		view?.setupLogoImageView(imageNamed: imageNamed)
		view?.setupViewBackgroundColor(backgroundColorHexString: backgroundColorHexString)
		view?.setupLabels(title: title, description: description)
		
	}

}
