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
	
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var skipButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var logoImageView: UIImageView!
	
  @IBOutlet weak var constraintImageTopForBigScreen: NSLayoutConstraint! // Start priority: 1000
  @IBOutlet weak var constraintImageTopForSmallScreen: NSLayoutConstraint! // Start priority: 250

  @IBOutlet weak var constraintButtonNextLeading: NSLayoutConstraint!
  @IBOutlet weak var constraintButtonNextCenterX: NSLayoutConstraint!

  var presenter: PresentationPresenterProtocol?
	var index: PresentationIndex?

  override func viewDidLoad() {
		super.viewDidLoad()

    let isBigScreen = UIScreen.main.sizeType.rawValue > SizeType.iPhone5.rawValue
    constraintImageTopForBigScreen.priority = isBigScreen ? UILayoutPriority.defaultHigh : UILayoutPriority.defaultLow
    constraintImageTopForSmallScreen.priority = isBigScreen ? UILayoutPriority.defaultLow : UILayoutPriority.defaultHigh

		presenter?.setupView()
		navigationController?.isNavigationBarHidden = true
		
		switch index! {
		case .first:
			pageControl.currentPage = 0
      skipButton.isHidden = false
      constraintButtonNextLeading.priority = UILayoutPriority.defaultHigh
      constraintButtonNextCenterX.priority = UILayoutPriority.defaultLow
		case .second:
			pageControl.currentPage = 1
      skipButton.isHidden = false
      constraintButtonNextLeading.priority = UILayoutPriority.defaultHigh
      constraintButtonNextCenterX.priority = UILayoutPriority.defaultLow
		case .third:
			pageControl.currentPage = 2
      skipButton.isHidden = true
      constraintButtonNextLeading.priority = UILayoutPriority.defaultLow
      constraintButtonNextCenterX.priority = UILayoutPriority.defaultHigh
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupButtons()
	}
	
	func setupButtons() {
		nextButton.round()
		skipButton.round()
		skipButton.setBorder(width: 2, color: .white)
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
	
	func setupLabels(title:String, titleFont:UIFont?, description:String, descriptionFont:UIFont?) {
		titleLabel.text = title
		descriptionLabel.text = description
		
		if let titleFont = titleFont {
			titleLabel.font = titleFont
		}
		if let descriptionFont = descriptionFont {
			descriptionLabel.font = descriptionFont
		}
	}
	
}
