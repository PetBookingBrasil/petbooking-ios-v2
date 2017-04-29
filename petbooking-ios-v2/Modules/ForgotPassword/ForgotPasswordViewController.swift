//
//  ForgotPasswordViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 29/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class ForgotPasswordViewController: UIViewController, ForgotPasswordViewProtocol {

	
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	
	var presenter: ForgotPasswordPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.isNavigationBarHidden = false
		self.title = "Esqueci a senha"
		hideKeyboardWhenTappedAround()
		}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupButtons()
	}
	
	func setupButtons() {
		sendButton.round()
	}

	
	@IBAction func send(_ sender: Any) {
	}

}
