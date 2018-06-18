//
//  PetSizePopupViewController.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 06/06/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class PetSizePopupViewController: UIViewController {

	@IBOutlet weak var popupContentContainerView: UIView!
	@IBOutlet weak var dismissButton: UIButton!
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
		view.frame = CGRect(x:0,y:0, width: Device.TheCurrentDeviceWidth, height: Device.TheCurrentDeviceHeight)
		popupContentContainerView.layer.masksToBounds = true
		popupContentContainerView.layer.cornerRadius = 10
		dismissButton.round()
	}
	
	@IBAction func dismissAlert(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}

extension PetSizePopupViewController: MIBlurPopupDelegate {
	
	var popupView: UIView {
		return popupContentContainerView ?? UIView()
	}
	var blurEffectStyle: UIBlurEffectStyle {
		return .dark
	}
	var initialScaleAmmount: CGFloat {
		return 0.0
	}
	var animationDuration: TimeInterval {
		return 0.5
	}
}
