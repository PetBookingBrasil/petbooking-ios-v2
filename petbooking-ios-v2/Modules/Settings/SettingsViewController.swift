//
//  SettingsViewController.swift
//  petbooking-ios-v2
//
//  Created David Batista on 08/04/18.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//

import UIKit
import ALLoadingView

class SettingsViewController: UIViewController, SettingsViewProtocol {

	var presenter: SettingsPresenterProtocol?
    
    //IBOUtlets
    @IBOutlet weak var kmConteinerView: UIView!
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var kmSlider: UISlider!
    
    @IBOutlet weak var pushSwitch: UISwitch!
    @IBOutlet weak var emailSwitch: UISwitch!
    @IBOutlet weak var smsSwitch: UISwitch!
    
	override func viewDidLoad() {
        super.viewDidLoad()
		
		setBackButton()
        setupView()
		
		title = "Configurações"
    }
    
    func setupView() {
        kmConteinerView.layer.borderWidth = 1
        kmConteinerView.layer.borderColor = UIColor.lightGray.cgColor
        kmConteinerView.layer.cornerRadius = kmConteinerView.frame.height / 2
    }
	
    override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.navigationBar.barTintColor = UIColor(hex: "E4002B")
	}
}

extension SettingsViewController {
    @IBAction func contactButtonTapped(_ sender: Any) { }
    @IBAction func supportButtonTapped(_ sender: Any) { }
    @IBAction func legalButtonTapped(_ sender: Any) { }
}
