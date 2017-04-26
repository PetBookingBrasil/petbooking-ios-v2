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
	var index:PresentationIndex?
	
	func didTapNextButton() {
		
		switch index! {
		case .first:
			presenter?.nextView(index: .second)
			break
		case .second:
			presenter?.nextView(index: .third)
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
			presenter?.setupView(imageNamed: "apt_01", backgroundColorHexString: "fbcfd5", title: NSLocalizedString("ap1_title", comment: ""), description: NSLocalizedString("ap1_description", comment: ""))
			break
		case .second:
			presenter?.setupView(imageNamed: "apt_02", backgroundColorHexString: "f6dac4", title:  NSLocalizedString("ap2_title", comment: ""), description:  NSLocalizedString("ap2_description", comment: ""))
			break
		case .third:
			presenter?.setupView(imageNamed: "apt_03", backgroundColorHexString: "abdeda", title:  NSLocalizedString("ap3_title", comment: ""), description:  NSLocalizedString("ap3_description", comment: ""))
			break
		}
		
	}
	
}

enum PresentationIndex {
	case first, second, third
}
