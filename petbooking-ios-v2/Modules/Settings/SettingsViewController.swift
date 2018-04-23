//
//  SettingsViewController.swift
//  petbooking-ios-v2
//
//  Created David Batista on 08/04/18.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit
import ALLoadingView

class SettingsViewController: UIViewController, SettingsViewProtocol {
    
    static let HTTP_PROTOCOL = "https://"
    static let BASE_URL = Bundle.main.infoDictionary!["BASE_URL"] as! String
    static let WEB_BASE_URL = "\(HTTP_PROTOCOL)\(BASE_URL)"

	var presenter: SettingsPresenterProtocol?
    
    let user = UserManager.sharedInstance.getCurrentUser()
    
    //IBOUtlets
    @IBOutlet weak var kmConteinerView: UIView!
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var kmSlider: UISlider!
    
    @IBOutlet weak var pushSwitch: UISwitch!
    @IBOutlet weak var emailSwitch: UISwitch!
    @IBOutlet weak var smsSwitch: UISwitch!
    
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setBackButton()
        setupView()
    }
    
    func setupView() {
        title = "Configurações"

        kmConteinerView.layer.borderWidth = 1
        kmConteinerView.layer.borderColor = UIColor.lightGray.cgColor
        kmConteinerView.layer.cornerRadius = kmConteinerView.frame.height / 2
        
        contactButton.contentHorizontalAlignment = .left
        termsButton.contentHorizontalAlignment = .left
        privacyButton.contentHorizontalAlignment = .left
        
        if case user?.acceptsPush = true {
            pushSwitch.isOn = true
        } else {
            pushSwitch.isOn = false
        }
        
        if case user?.acceptsEmail = true {
            emailSwitch.isOn = true
        } else {
            emailSwitch.isOn = false
        }

        if case user?.acceptsSms = true {
            smsSwitch.isOn = true
        } else {
            smsSwitch.isOn = false
        }
        
        if let range = user?.searchRange {
            kmSlider.value = range / 100.0
            kmLabel.text = "\(Int(range))km"
        } else {
            kmSlider.value = 0.5
            kmLabel.text = "50km"
        }
    }
	
    override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.navigationBar.barTintColor = UIColor(hex: "E4002B")
	}
    
    @IBAction func kmSliderChanged(_ sender: UISlider) {
        self.switchUpdate()
        kmLabel.text = "\(Int(sender.value*100.0))km"
    }
    
    @IBAction func pushSwitchChanged(_ sender: UISwitch) {
        self.switchUpdate()
    }
    
    @IBAction func emailSwitchChanged(_ sender: UISwitch) {
        self.switchUpdate()
    }
    
    @IBAction func smsSwitchChanged(_ sender: UISwitch) {
        self.switchUpdate()
    }
    
    func switchUpdate() {
        PetbookingAPI.sharedInstance.updateConfig(push: pushSwitch.isOn, email: emailSwitch.isOn, sms: smsSwitch.isOn, range: kmSlider.value, completion: nil)
    }
}

extension SettingsViewController {
    @IBAction func contactButtonTapped(_ sender: Any) {
        guard let url = URL(string: "\(SettingsViewController.WEB_BASE_URL)/webviews/contact") else { return }
        
        let webviewRequest = WebviewRequest(title: "Contato", url: url)
        
        let webview = WebviewRouter.createModule(from: webviewRequest)
        self.navigationController?.pushViewController(webview, animated: true)
    }
    
    @IBAction func termsButtonTapped(_ sender: Any) {
        guard let url = URL(string: "\(SettingsViewController.WEB_BASE_URL)/v2/webviews/termos_de_uso") else { return }

        let webviewRequest = WebviewRequest(title: "Termos de uso", url: url)

        let webview = WebviewRouter.createModule(from: webviewRequest)
        self.navigationController?.pushViewController(webview, animated: true)
    }
    
    @IBAction func privacyButtonTapped(_ sender: Any) {
        guard let url = URL(string: "\(SettingsViewController.WEB_BASE_URL)/v2/webviews/privacidade") else { return }

        let webviewRequest = WebviewRequest(title: "Políticas de privacidade", url: url)

        let webview = WebviewRouter.createModule(from: webviewRequest)
        self.navigationController?.pushViewController(webview, animated: true)
    }
}
