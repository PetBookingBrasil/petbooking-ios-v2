//
//  PresentationViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 26/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//

import UIKit

class PresentationViewController: UIViewController, PresentationViewProtocol {
	
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var skipButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var logoImageView: UIImageView!
	
	
	var presenter: PresentationPresenterProtocol?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupButtons()
		
		presenter?.setupView()
		self.navigationController?.isNavigationBarHidden = true
	}
	
	func setupButtons() {
		nextButton.roundButton()
		skipButton.roundButton()
		skipButton.buttonWithBorder(width: 2, color: .white)
	}
	
	@IBAction func next(_ sender: Any) {
		presenter?.didTapNextButton()
	}
	
	@IBAction func skip(_ sender: Any) {
		presenter?.didTapSkipButton()
	}
	
	func setupLogoImageView(imageNamed:String) {
		logoImageView.image = UIImage(named: imageNamed)
	}
	
	func setupViewBackgroundColor(backgroundColorHexString:String) {
		
		let backgroundColor = UIColor(hex: backgroundColorHexString)
		view.backgroundColor = backgroundColor
		nextButton.setTitleColor(backgroundColor, for: .normal)
		
	}
	
	func setupLabels(title:String, description:String) {
		titleLabel.text = title
		descriptionLabel.text = description
	}
	
}
