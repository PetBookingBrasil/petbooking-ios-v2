//
//  PresentationInteractor.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 26/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//

import UIKit

class PresentationInteractor: PresentationInteractorProtocol {
	
	weak var presenter: PresentationPresenterProtocol?
	weak var parentView: PresentationParentProtocol?
	var index:PresentationIndex?
	
	func didTapNextButton() {
		
		switch index! {
		case .first:
			parentView?.nextPage()
			break
		case .second:
			parentView?.nextPage()
			break
		case .third:
			presenter?.skipPresentationView()
			break
		}
		
	}
	
	func didTapSkipButton() {
		presenter?.skipPresentationView()
	}
	
	func setupView() {
		
		guard let index = index else {
			return
		}
		switch index {
		case .first:
			presenter?.setupView(imageNamed: "apt_01", backgroundColorHexString: "009CDE", title: NSLocalizedString("ap1_title", comment: ""), titleFont: nil, description: NSLocalizedString("ap1_description", comment: ""), descriptionFont: nil)
			break
		case .second:
			presenter?.setupView(imageNamed: "apt_02", backgroundColorHexString: "F68D2E", title:  NSLocalizedString("ap2_title", comment: ""), titleFont: nil, description:  NSLocalizedString("ap2_description", comment: ""), descriptionFont: nil)
			break
		case .third:
			presenter?.setupView(imageNamed: "apt_03", backgroundColorHexString: "9F5CC0", title:  NSLocalizedString("ap3_title", comment: ""), titleFont: UIFont.systemFont(ofSize: 18), description:  NSLocalizedString("ap3_description", comment: ""), descriptionFont: UIFont.boldSystemFont(ofSize: 20))
			break
		}
		
	}
	
}

enum PresentationIndex {
	case first, second, third
}
