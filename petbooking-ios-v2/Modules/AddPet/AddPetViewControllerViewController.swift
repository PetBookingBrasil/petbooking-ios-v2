//
//  AddPetViewControllerViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 25/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import AKMaskField
import ALLoadingView

class AddPetViewControllerViewController: UIViewController, AddPetViewControllerViewProtocol {
	
	@IBOutlet weak var picker: UIPickerView!
	
	@IBOutlet weak var pickerView: UIView!
	var petPickerType: PetPickerType = .gender
	
	@IBOutlet weak var profilePictureView: UIView!
	@IBOutlet weak var profilePictureImageView: UIImageView!
			
	@IBOutlet weak var petNameTextField: UITextField!
    @IBOutlet weak var observationTextField: UITextField!
    @IBOutlet weak var birthdayTextField: AKMaskField!
    @IBOutlet weak var chipNumberTextField: UITextField!
    
    @IBOutlet weak var petTypeLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var petSizeLabel: UILabel!
	@IBOutlet weak var moodLabel: UILabel!
	@IBOutlet weak var coatLabel: UILabel!
    @IBOutlet weak var petColorLabel: UILabel!
	
	@IBOutlet weak var petPictureAlertMessageLabel: UILabel!
	@IBOutlet weak var petNameAlertMessageLabel: UILabel!
    @IBOutlet weak var petKindAlertMessageLabel: UILabel!
	@IBOutlet weak var birthdayAlertMessageLabel: UILabel!
    @IBOutlet weak var petBreedAlertMessageLabel: UILabel!
	@IBOutlet weak var genderAlertMessageLabel: UILabel!
    @IBOutlet weak var petSizeAlertMessageLabel: UILabel!
    @IBOutlet weak var moodAlertMessageLabel: UILabel!
	@IBOutlet weak var coatAlertMessageLabel: UILabel!
    @IBOutlet weak var petColorAlertMessageLabel: UILabel!
    @IBOutlet weak var chipNumberAlertMessageLabel: UILabel!
    
    @IBOutlet weak var castratedSwitch: UISwitch!
    @IBOutlet weak var hasChipSwitch: UISwitch!
    
    @IBOutlet weak var saveButton: UIButton!
	@IBOutlet weak var petSizeInfoButton: UIButton!
		
	var petViewType: PetViewType?
	
	var breedList = [Breed]()
	var petBreedIndex = 0
	
	var petTypeList: [PetTypeEnum] = [.dog, .cat, .pig]
	var petTypeIndex = 0
	
	var genderList: [PetGenderEnum] = [.male, .female]
	var petGenderIndex = 0
	
	var coatList: [PetCoatEnum] = [.short, .medium, .long]
	var petCoatIndex = 0
	
	var temperList: [PetMoodEnum] = [.agitated, .happy, .loving, .angry, .playful, .needy, .affectionate, .calm, .brave]
	var petTemperIndex = 0
	
	var petSizeList: [PetSizeEnum] = [.small, .medium, .big, .giant]
	var petSizeIndex = 0
	
	var petCoatColorList: [PetCoatColorEnum] = [.yellow, .blue, .white, .gray, .chocolate, .cream, .gold, .silver, .black, .red]
	var petCoatColorIndex = 0
	
	var presenter: AddPetViewControllerPresenterProtocol?
	
	var pet: Pet! = Pet()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setBackButton()
		setTitle(title: NSLocalizedString("add_pet_title", comment: ""))
		profilePictureView.round()
		saveButton.round()
				
		let image = UIImage(named: "info")?.withRenderingMode(.alwaysTemplate)
		petSizeInfoButton.setImage(image, for: .normal)
		
		birthdayTextField.maskExpression = "{dd}/{dd}/{dddd}"
		birthdayTextField.maskTemplate = "dd/mm/aaaa"
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapField(_:)))
		genderLabel.addGestureRecognizer(tapGesture)
		
		let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(tapField(_:)))
		petTypeLabel.addGestureRecognizer(tapGesture2)
		
		let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(tapField(_:)))
		breedLabel.addGestureRecognizer(tapGesture3)
		
		let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(tapField(_:)))
		moodLabel.addGestureRecognizer(tapGesture4)
		
		let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(tapField(_:)))
		coatLabel.addGestureRecognizer(tapGesture5)
		
		let tapGesture6 = UITapGestureRecognizer(target: self, action: #selector(tapField(_:)))
		petSizeLabel.addGestureRecognizer(tapGesture6)
		
		let tapGesture7 = UITapGestureRecognizer(target: self, action: #selector(tapField(_:)))
		petColorLabel.addGestureRecognizer(tapGesture7)
		
		picker.dataSource = self
		picker.delegate = self
		
		if petViewType == .edit {
			setTitle(title: NSLocalizedString("edit_pet_title", comment: ""))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "remove_pet".localized,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(removePet))
			saveButton.backgroundColor = UIColor(hex: "E4002B")
			saveButton.setTitle("save_pet".localized, for: .normal)
			saveButton.setTitleColor(UIColor.white, for: .normal)
			saveButton.removeTarget(nil, action: nil, for: .allEvents)
			
			saveButton.addTarget(self, action: #selector(AddPetViewControllerViewController.save(_:)), for: .touchUpInside)
		}
        
		hideKeyboardWhenTappedAround()
		
		if !pet.name.isBlank {
			
			if let url = URL(string: pet.photoUrl) {
				profilePictureImageView.pin_setImage(from: url)
			}
			
			petNameTextField.text = pet.name
			
			if !pet.birthday.isBlank {
                let dateFormatter = DateFormatter()
                birthdayTextField.text = dateFormatter.convertDateFormater(dateString: pet.birthday, fromFormat: "yyyy-MM-dd", toFormat: "dd/MM/yyyy")
			}
			
			observationTextField.text = pet.petDescription
			
			guard let coat = PetCoatEnum(rawValue: pet.coatSize) else { return }
			guard let indexCoat = coatList.index(of: coat) else { return }
            
			petCoatIndex = indexCoat
			coatLabel.text = "pet_coat_size_\(pet.coatSize)".localized
			petColorLabel.text = "pet_coat_color_\(pet.coatColor)".localized
			
			guard let type = PetTypeEnum(rawValue: pet.type) else { return }
			guard let indexType = petTypeList.index(of: type) else { return }
            
			petTypeIndex = indexType
			petTypeLabel.text = "pet_type_\(pet.type)".localized
			
			self.breedLabel.text = self.pet.breedName
			
			PetbookingAPI.sharedInstance.getBreedList(petType: pet.type) { (breedList, message) in
				guard let breedList = breedList else { return }
                
				self.breedList = breedList.breeds
			}
			
			guard let gender = PetGenderEnum(rawValue: pet.gender) else { return }
			guard let indexGender = genderList.index(of: gender) else { return }
            
			petGenderIndex = indexGender
			genderLabel.text = "pet_gender_\(pet.gender)".localized
			
			guard let size = PetSizeEnum(rawValue: pet.size) else { return }
			guard let indexSize = petSizeList.index(of: size) else { return }
            
			petSizeIndex = indexSize
			petSizeLabel.text = "pet_size_\(pet.size)".localized
			
			moodLabel.text = "pet_mood_\(pet.mood)".localized
		}
	}
	
    @IBAction func hasChipSwitchChanged(_ sender: Any) {
        if hasChipSwitch.isOn {
            chipNumberTextField.isEnabled = true
        } else {
            chipNumberTextField.isEnabled = false
        }
    }
    
    @IBAction func changeAvatar(_ sender: Any) {
		MIBlurPopup.show(SelectPhotoSourcePopupRouter.createModule(delegate: self), on: self)
	}
	
    @objc func tapField(_ sender: UITapGestureRecognizer) {
		self.view.endEditing(true)
		guard let label = sender.view as? UILabel else { return }
		
		var index = 0
		switch label {
		case genderLabel:
			petPickerType = .gender
			index = petGenderIndex
        
        case petTypeLabel:
			petPickerType = .petType
			index = petTypeIndex

        case breedLabel:
			if breedList.isEmpty {
				let breed = Breed()!
				breed.name = NSLocalizedString("select_pet_kind", comment: "")
				breedList.append(breed)
			}
            
			petPickerType = .breed
			index = petBreedIndex

        case coatLabel:
			petPickerType = .coat
			index = petCoatIndex

        case moodLabel:
			petPickerType = .temper
			index = petTemperIndex

        case petSizeLabel:
			petPickerType = .petSize
			index = petSizeIndex

        case petColorLabel:
			petPickerType = .coatColor
			index = petCoatColorIndex

        default:
            break
		}
		
		picker.reloadAllComponents()
		picker.selectRow(index, inComponent: 0, animated: false)
		pickerView.isHidden = false
	}
    
	@IBAction func doneTapped(_ sender: Any) {
		pickerView.isHidden = true
		
		let index = picker.selectedRow(inComponent: 0)
		
		switch petPickerType {
		case .breed:
			pet.breedName = breedList[index].name
			pet.breedId = Int(breedList[index].id)!
			
			if pet.breedId != 0 {
				breedLabel.text = pet.breedName
			}
            
			petBreedIndex = index

        case .coat:
			petCoatIndex = index
			pet.coatSize = coatList[index].rawValue
			coatLabel.text = "pet_coat_size_\(pet.coatSize)".localized

        case .gender:
			pet.gender = genderList[index].rawValue
			genderLabel.text = "pet_gender_\(pet.gender)".localized
			petGenderIndex = index

        case .petSize:
			petSizeIndex = index
			pet.size = petSizeList[index].rawValue
			petSizeLabel.text = "pet_size_\(pet.size)".localized

        case .temper:
			petTemperIndex = index
			pet.mood = temperList[index].rawValue
			moodLabel.text = "pet_mood_\(pet.mood)".localized

        case .coatColor:
			petCoatColorIndex = index
			pet.coatColor = petCoatColorList[index].rawValue
			petColorLabel.text = "pet_coat_color_\(pet.coatColor)".localized

        case .petType:
			let currentPetType = pet.type
			pet.type = petTypeList[index].rawValue
			petTypeLabel.text = "pet_type_\(pet.type)".localized
			petTypeIndex = index
            
			if currentPetType != pet.type {
				pet.breedName = ""
				pet.breedId = 0
				self.breedLabel.text = "pet_breed_field".localized
			}
			
			PetbookingAPI.sharedInstance.getBreedList(petType: pet.type) { (breedList, message) in
				guard let breedList = breedList else { return }
				
				self.breedList = breedList.breeds
			}
		}
	}
	
	@IBAction func showPetSizeInfo(_ sender: Any) {
		MIBlurPopup.show(PetSizePopupViewController(), on: self)
	}
	
    @objc func removePet() {
		ALLoadingView.manager.showLoadingView(ofType: .basic)
		
        PetbookingAPI.sharedInstance.deletePet(pet: self.pet) { (pet, message) in
			ALLoadingView.manager.hideLoadingView()
			self.navigationController?.popViewController(animated: true)
		}
	}
	
	@IBAction func save(_ sender: Any) {
		
		var isValid = true
		
		let name = petNameTextField.checkField()
		if checkValidField(value: name, alertLabel: petNameAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_name", comment: "")) {
			pet.name = name!
		} else {
			isValid = false
		}
		
		if let observation = observationTextField.text {
			pet.petDescription = observation
		}
		
		let birthday = birthdayTextField.checkField()
		if checkValidField(value: birthday, alertLabel: birthdayAlertMessageLabel, alertMessage: NSLocalizedString("invalid_birthday", comment: "")) {
			pet.birthday = birthday!
		} else {
			isValid = false
		}
		
		if pet.breedId == 0 && pet.type != PetTypeEnum.pig.rawValue {
			isValid = false
			_ = checkValidField(value: nil, alertLabel: petBreedAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_breed", comment: ""))
		} else {
			_ = checkValidField(value: "ok", alertLabel: petBreedAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_breed", comment: ""))
		}
		
		if pet.coatSize.isBlank {
			isValid = false
			_ = checkValidField(value: nil, alertLabel: coatAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_coat", comment: ""))
		} else {
			_ = checkValidField(value: "ok", alertLabel: coatAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_coat", comment: ""))
		}
		
		if pet.type.isBlank {
			isValid = false
			_ = checkValidField(value: nil, alertLabel: petKindAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_kind", comment: ""))
		} else {
			_ = checkValidField(value: "ok", alertLabel: petKindAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_kind", comment: ""))
		}
		
		if pet.size.isBlank {
			isValid = false
			_ = checkValidField(value: nil, alertLabel: petSizeAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_size", comment: ""))
		} else {
			_ = checkValidField(value: "ok", alertLabel: petSizeAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_size", comment: ""))
		}
		
		if pet.gender.isBlank {
			isValid = false
			_ = checkValidField(value: nil, alertLabel: genderAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_gender", comment: ""))
		} else {
			_ = checkValidField(value: "ok", alertLabel: genderAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_gender", comment: ""))
		}
		
		if pet.mood.isBlank {
			isValid = false
			_ = checkValidField(value: nil, alertLabel: moodAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_mood", comment: ""))
		} else {
			_ = checkValidField(value: "ok", alertLabel: moodAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_mood", comment: ""))
		}
        
        if pet.coatColor == -1 {
            isValid = false
            _ = checkValidField(value: nil, alertLabel: petColorAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_color", comment: ""))
        } else {
            _ = checkValidField(value: "ok", alertLabel: petColorAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_color", comment: ""))
        }
        
        if hasChipSwitch.isOn {
            let chipNumber = chipNumberTextField.checkField()
            if checkValidField(value: chipNumber, alertLabel: chipNumberAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_chip_number", comment: "")) {
                pet.chipNumber = chipNumber!
            } else {
                isValid = false
            }
        } else {
            pet.chipNumber = ""
            _ = checkValidField(value: "ok", alertLabel: chipNumberAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_chip_number", comment: ""))
        }
		
		//		if pet.photoUrl.isBlank {
		//			isValid = false
		//			_ = checkValidField(value: nil, alertLabel: petPictureAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_picture", comment: ""))
		//		} else {
		//			_ = checkValidField(value: "ok", alertLabel: petPictureAlertMessageLabel, alertMessage: NSLocalizedString("invalid_pet_picture", comment: ""))
		//		}
		
		if isValid {
			presenter?.didtapSaveButton(pet: self.pet)
		}
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
	
	func showAlertMessage(title: String, message: String) { }
}

extension AddPetViewControllerViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			profilePictureImageView.image = image
			
			guard let base64Avatar = image.toBase64String() else { return }
			
			pet.photoUrl = "data:image/jpeg;base64,\(base64Avatar)"
		}
		
		picker.dismiss(animated: true, completion: nil);
	}
}

extension AddPetViewControllerViewController: SelectPhotoSourcePopupActionProtocol {
	
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

extension AddPetViewControllerViewController:UIPickerViewDataSource, UIPickerViewDelegate {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch petPickerType {
		case .breed:
			return breedList.count
		case .coat:
			return coatList.count
		case .gender:
			return genderList.count
		case .petSize:
			return petSizeList.count
		case .temper:
			return temperList.count
		case .petType:
			return petTypeList.count
		case .coatColor:
			return petCoatColorList.count
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		var key = ""
		switch petPickerType {
		case .breed:
			key =  breedList[row].name
		case .coat:
			key = "pet_coat_size_\(coatList[row].rawValue)"
		case .gender:
			key = "pet_gender_\(genderList[row].rawValue)"
		case .petSize:
			key = "pet_size_\(petSizeList[row].rawValue)"
		case .temper:
			key = "pet_mood_\(temperList[row].rawValue)"
		case .petType:
			key = "pet_type_\(petTypeList[row].rawValue)"
		case .coatColor:
			key = "pet_coat_color_\(petCoatColorList[row].rawValue)"
		}
		
		return key.localized
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { }
}
