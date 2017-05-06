//
//  SignupViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 29/04/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import PINRemoteImage
import AKMaskField

class SignupViewController: UIViewController, SignupViewProtocol {

	
	@IBOutlet weak var profilePictureView: UIView!
	@IBOutlet weak var profilePictureImageView: UIImageView!
	@IBOutlet weak var profilePictureFrameView: UIView!
	@IBOutlet weak var fullNameTextField: UITextField!
	@IBOutlet weak var cpfTextField: AKMaskField!
	@IBOutlet weak var birthdayTextField: AKMaskField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var confirmPasswordTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var mobileNumberTextField: AKMaskField!
	@IBOutlet weak var numberTextField: UITextField!
	@IBOutlet weak var cityTextField: UITextField!
	@IBOutlet weak var neighborhoodTextField: UITextField!
	@IBOutlet weak var zipcodeTextField: AKMaskField!
	@IBOutlet weak var stateTextField: UITextField!
	@IBOutlet weak var streetTextField: UITextField!
	@IBOutlet weak var saveButton: UIButton!
	
	@IBOutlet weak var cameraIconImageView: UIImageView!
	@IBOutlet weak var cpfIconImageView: UIImageView!
	@IBOutlet weak var userIconImageView: UIImageView!
	@IBOutlet weak var birthdayIconImageView: UIImageView!
	@IBOutlet weak var emailIconImageView: UIImageView!
	@IBOutlet weak var locationIconImageView: UIImageView!
	@IBOutlet weak var phoneIconImageView: UIImageView!
	@IBOutlet weak var cepIconImageView: UIImageView!
	@IBOutlet weak var numberIconImageView: UIImageView!
	@IBOutlet weak var stateIconImageView: UIImageView!
	@IBOutlet weak var cityIconImageView: UIImageView!
	@IBOutlet weak var confirmPasswordIconImageView: UIImageView!
	@IBOutlet weak var passwordIconImageView: UIImageView!
	@IBOutlet weak var neighborhoodIconImageView: UIImageView!
	
	
	var presenter: SignupPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationController?.isNavigationBarHidden = false
		self.title = "Preencha os seus dados"
		hideKeyboardWhenTappedAround()
				setupView()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		presenter?.fillFields()
	}
	
	func setupView() {
		profilePictureView.round()
		profilePictureFrameView.setBorder(width: 2, color: .white)
		profilePictureFrameView.round()
		saveButton.round()
		
		cpfTextField.maskExpression = "{ddd}.{ddd}.{ddd}-{dd}"
		cpfTextField.maskTemplate = "xxx.xxx.xxx-xx"
		
		birthdayTextField.maskExpression = "{dd}/{dd}/{dddd}"
		birthdayTextField.maskTemplate = "dd/mm/aaaa"
		
		mobileNumberTextField.maskExpression = "({dd}){ddddd}-{dddd}"
		mobileNumberTextField.maskTemplate = "(xx)xxxxx-xxxx"
		
		zipcodeTextField.maskExpression = "{ddddd}-{ddd}"
		zipcodeTextField.maskTemplate = "xxxxx-xxx"
		zipcodeTextField.maskDelegate = self
		
		cameraIconImageView.image = cameraIconImageView.image!.withRenderingMode(.alwaysTemplate)
		cameraIconImageView.tintColor = .white
		
		cpfIconImageView.image = cpfIconImageView.image!.withRenderingMode(.alwaysTemplate)
		cpfIconImageView.tintColor = .black
		
		userIconImageView.image = userIconImageView.image!.withRenderingMode(.alwaysTemplate)
		userIconImageView.tintColor = .black
		
		birthdayIconImageView.image = birthdayIconImageView.image!.withRenderingMode(.alwaysTemplate)
		birthdayIconImageView.tintColor = .black
		
		emailIconImageView.image = emailIconImageView.image!.withRenderingMode(.alwaysTemplate)
		emailIconImageView.tintColor = .black
		
		locationIconImageView.image = locationIconImageView.image!.withRenderingMode(.alwaysTemplate)
		locationIconImageView.tintColor = .black
		
		neighborhoodIconImageView.image = neighborhoodIconImageView.image!.withRenderingMode(.alwaysTemplate)
		neighborhoodIconImageView.tintColor = .black
		
		cepIconImageView.image = cepIconImageView.image!.withRenderingMode(.alwaysTemplate)
		cepIconImageView.tintColor = .black
		
		numberIconImageView.image = numberIconImageView.image!.withRenderingMode(.alwaysTemplate)
		numberIconImageView.tintColor = .black
		
		cityIconImageView.image = cityIconImageView.image!.withRenderingMode(.alwaysTemplate)
		cityIconImageView.tintColor = .black
		
		stateIconImageView.image = stateIconImageView.image!.withRenderingMode(.alwaysTemplate)
		stateIconImageView.tintColor = .black
		
		phoneIconImageView.image = phoneIconImageView.image!.withRenderingMode(.alwaysTemplate)
		phoneIconImageView.tintColor = .black
		
		confirmPasswordIconImageView.image = confirmPasswordIconImageView.image!.withRenderingMode(.alwaysTemplate)
		confirmPasswordIconImageView.tintColor = .black
		
		passwordIconImageView.image = passwordIconImageView.image!.withRenderingMode(.alwaysTemplate)
		passwordIconImageView.tintColor = .black
		
	}

	@IBAction func changeAvatar(_ sender: Any) {
		
		if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
			
			 let imagePicker = UIImagePickerController()
			
			imagePicker.delegate = self
			imagePicker.sourceType = .savedPhotosAlbum;
			imagePicker.allowsEditing = false
			
			self.present(imagePicker, animated: true, completion: nil)
		}
		
	}
	
	@IBAction func save(_ sender: Any) {
		
		guard let name = fullNameTextField.text else {
			return
		}
		
		guard let cpf = cpfTextField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() else {
			return
		}
		
		guard let birthday = birthdayTextField.text else {
			return
		}
		
		guard let email = emailTextField.text else {
			return
		}
		
		guard let mobile = mobileNumberTextField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() else {
			return
		}
		
		guard let zipcode = zipcodeTextField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() else {
			return
		}
		
		guard let street = streetTextField.text else {
			return
		}
		
		guard let streetNumber = numberTextField.text else {
			return
		}
		
		guard let neighborhood = neighborhoodTextField.text else {
			return
		}
		
		guard let city = cityTextField.text else {
			return
		}
		
		guard let state = stateTextField.text else {
			return
		}
		
		guard let password = passwordTextField.text else {
			return
		}
		
		guard let confirmPassword = confirmPasswordTextField.text else {
			return
		}
		
		if password != confirmPassword {
			return
		}
		
		guard let image = profilePictureImageView.image else {
			return
		}
		
		guard let base64Avatar = image.toBase64String() else {
			return
		}
		
		
		presenter?.createUser(name: name, cpf: cpf, birthday: birthday, email: email, mobile: mobile, zipcode: zipcode, street: street, streetNumber: streetNumber, neighborhood: neighborhood, city: city, state: state, password: password, avatar:"data:image/jpeg;base64,\(base64Avatar)")
	}
	
	func setProfileImageView(urlString:String) {
		
		if let url = URL(string: urlString) {
			profilePictureImageView.pin_setImage(from: url)
		}
		
	}
	
	func setNameLabel(name:String) {
		
		fullNameTextField.text = name
	}
	
	func setEmail(email:String) {
		
		emailTextField.text = email
	}
	
	func fillAdrressFields(street:String, neighborhood:String, city:String, state:String) {
		
		streetTextField.text = street
		neighborhoodTextField.text = neighborhood
		cityTextField.text = city
		stateTextField.text = state
		
	}
	
	
}

extension SignupViewController:UITextFieldDelegate, AKMaskFieldDelegate {
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		switch textField {
		case zipcodeTextField:
			break
		case stateTextField:
			guard let text = textField.text else {
				return true
			}
			if text.characters.count >= 2 && !string.isEmpty || string.characters.count > 2{
				return false
			}
			break
			
		default:
			break
		}
		
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		switch textField {
		case zipcodeTextField:
			guard let zipcode = textField.text else {
				return
			}
			presenter?.fillAdrressWithZipcode(zipcode: zipcode)
			break
			case stateTextField:
				textField.text = textField.text?.uppercased()
			break
			
		default:
			break
		}
	}
	
	func maskFieldDidEndEditing(_ maskField: AKMaskField) {
		switch maskField {
		case zipcodeTextField:
			guard let zipcode = maskField.text else {
				return
			}
			presenter?.fillAdrressWithZipcode(zipcode: zipcode)
			break
			
		default:
			break
		}
	}
}

extension SignupViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			profilePictureImageView.image = image
		}
		
		picker.dismiss(animated: true, completion: nil);
	}
	
}
