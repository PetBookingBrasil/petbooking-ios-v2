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
    
    // MARK: - Outlets
    @IBOutlet weak var profilePictureView: UIView!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var cameraIconImageView: UIImageView!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: AKMaskField!
    
    @IBOutlet weak var passwordSeparatorView: UIView!
    
    @IBOutlet weak var emailAlertMessageLabel: UILabel!
    @IBOutlet weak var passwordAlertMessageLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var viewPasswordButton: UIButton!
    
    // Facebook register outlets
    @IBOutlet weak var leadingPhotoConstraint: NSLayoutConstraint!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var fullNameFacebookLabel: UILabel!
    @IBOutlet weak var emailFacebookLabel: UILabel!
    @IBOutlet weak var mobileNumberFacebookTextField: AKMaskField!
    
    var presenter: SignupPresenterProtocol?
    var signupType: SignupType?
    var seePassword = false
    
    // MARK: - App lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cadastro"
        
        hideKeyboardWhenTappedAround()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupView() {
        setBackButton()
        
        profilePictureView.round()
        saveButton.round()
        
        mobileNumberTextField.maskExpression = "({dd}){ddddd}-{dddd}"
        mobileNumberTextField.maskTemplate = "(xx)xxxxx-xxxx"
        
        cameraIconImageView.image = cameraIconImageView.image!.withRenderingMode(.alwaysTemplate)
        cameraIconImageView.tintColor = .white
        
        leadingPhotoConstraint.constant = (UIScreen.main.bounds.width/2) - (profilePictureView.bounds.width/2)
        
        if UserDefaults.isFacebookLogin() {
            signupType = .editFacebook
        }
        
        switch signupType! {
        case .editFacebook:
            leadingPhotoConstraint.constant = 16
            topContainerView.isHidden = false
            bottomContainerView.isHidden = false
            
            self.title = "Editar Informações"
            saveButton.setTitle("Atualizar", for: .normal)
            
            saveButton.backgroundColor = UIColor.init(hex: "E4002B")
            saveButton.isEnabled = true
            
        case .editProfile:
            passwordTextField.isHidden = true
            passwordSeparatorView.isHidden = true
            viewPasswordButton.isHidden = true
            
            self.title = "Editar Informações"
            saveButton.setTitle("Atualizar", for: .normal)
            
            saveButton.backgroundColor = UIColor.init(hex: "E4002B")
            saveButton.isEnabled = true
            
        case .facebook:
            leadingPhotoConstraint.constant = 16
            topContainerView.isHidden = false
            bottomContainerView.isHidden = false
            
            saveButton.setTitle("Concluir cadastro", for: .normal)
            
        default:
            break
        }
        
        view.layoutIfNeeded()
        presenter?.fillFields()
    }
    
    func checkValidField(value: String?, alertLabel: UILabel, alertMessage: String) -> Bool {
        if value == nil {
            alertLabel.isHidden = false
            alertLabel.text = alertMessage
            
            return false
        }
        
        alertLabel.isHidden = true
        return true
    }
    
    func checkValidPasswordFields() -> Bool {
        guard signupType != .editProfile else { return true }
        
        let password = passwordTextField.checkField()
        if !checkValidField(value: password, alertLabel: passwordAlertMessageLabel,
                            alertMessage: NSLocalizedString("invalid_password", comment: "")) {
            return false
        }
        
        if password!.count < 8 {
            passwordAlertMessageLabel.isHidden = false
            passwordAlertMessageLabel.text = NSLocalizedString("invalid_password", comment: "")
            
            return false
        } else {
            passwordAlertMessageLabel.isHidden = true
        }
        
        return true
    }
    
    func setProfileImageView(withUrlString urlString: String) {
        if let url = URL(string: urlString) {
            profilePictureImageView.pin_setImage(from: url)
        }
    }
    
    func setName(_ name: String) {
        if signupType == .facebook || signupType == .editFacebook {
            fullNameFacebookLabel.text = name
        } else {
            fullNameTextField.text = name
        }
    }
    
    func setEmail(_ email: String) {
        if signupType == .facebook || signupType == .editFacebook {
            emailFacebookLabel.text = email
        } else {
            emailTextField.text = email
        }
    }
    
    func setMobile(_ mobile: String) {
        mobileNumberTextField.text = mobile
    }
    
    // MARK: - Actions
    @IBAction func viewPasswordButtonTapped() {
        if seePassword {
            viewPasswordButton.setTitle("Esconder senha", for: .normal)
        } else {
            viewPasswordButton.setTitle("Exibir senha", for: .normal)
        }
        
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        seePassword = !seePassword
    }
    
    @IBAction func changeAvatar(_ sender: Any) {
        MIBlurPopup.show(SelectPhotoSourcePopupRouter.createModule(delegate: self), on: self)
    }
    
    @IBAction func save(_ sender: Any) {
        var isValid = true
        
        var name = ""
        var mobile = ""
        var email = ""
        var password = ""
        
        if signupType == .facebook || signupType == .editFacebook {
            name = fullNameFacebookLabel.text!
            mobile = mobileNumberFacebookTextField.text!
            email = emailFacebookLabel.text!
            password = ""
        } else {
            name = fullNameTextField.text!
            
            email = emailTextField.text!
            if !email.isEmail {
                isValid = false
                _ = !checkValidField(value: nil, alertLabel: emailAlertMessageLabel,
                                     alertMessage: NSLocalizedString("invalid_email", comment: ""))
            } else {
                _ = !checkValidField(value: email, alertLabel: emailAlertMessageLabel,
                                     alertMessage: NSLocalizedString("invalid_email", comment: ""))
            }
            
            mobile = mobileNumberTextField.text!
            
            if let passText = passwordTextField.checkField() {
                password = passText
            }
            
            if !checkValidPasswordFields() {
                isValid = false
            }
        }
        
        var base64Avatar: String?
        
        if let image = profilePictureImageView.image, let base64 = image.toBase64String() {
            base64Avatar = "data:image/jpeg;base64,\(base64)"
        }
        
        guard isValid else { return }
        
        presenter?.createUser(name: name, email: email, mobile: mobile, password: password, avatar: base64Avatar)
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if signupType == .facebook || signupType == .editFacebook {
            guard !mobileNumberFacebookTextField.text!.isBlank else { return }
        } else {
            guard !fullNameTextField.text!.isBlank else { return }
            guard !emailTextField.text!.isBlank else { return }
            guard !mobileNumberTextField.text!.isBlank else { return }
            guard !passwordTextField.text!.isBlank else { return }
        }
        
        saveButton.backgroundColor = UIColor.init(hex: "E4002B")
        saveButton.isEnabled = true
    }
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePictureImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
}

extension SignupViewController: SelectPhotoSourcePopupActionProtocol {
    
    func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}
