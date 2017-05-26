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

class AddPetViewControllerViewController: UIViewController, AddPetViewControllerViewProtocol {

	@IBOutlet weak var profilePictureView: UIView!
	@IBOutlet weak var profilePictureImageView: UIImageView!
	@IBOutlet weak var profilePictureFrameView: UIView!
	
	@IBOutlet weak var petNameIconImageView: UIImageView!
	
	@IBOutlet weak var birthdayIconImageView: UIImageView!
	
	@IBOutlet weak var genderIconImageView: UIImageView!
	
	@IBOutlet weak var petSizeIconImageView: UIImageView!
	
	@IBOutlet weak var coatIconImageView: UIImageView!
	
	@IBOutlet weak var observationIconImageView: UIImageView!
	
	@IBOutlet weak var breedIconImageView: UIImageView!
	
	@IBOutlet weak var kindIconImageView: UIImageView!
	@IBOutlet weak var temperIconImageView: UIImageView!
	
	@IBOutlet weak var saveButton: UIButton!
	
	var presenter: AddPetViewControllerPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
		
		title = NSLocalizedString("add_pet_title", comment: "")
		
		profilePictureView.round()
		profilePictureFrameView.setBorder(width: 2, color: .white)
		profilePictureFrameView.round()
		saveButton.round()
		
		petNameIconImageView.changeImageColor(color: .black)
		birthdayIconImageView.changeImageColor(color: .black)
		genderIconImageView.changeImageColor(color: .black)
		petSizeIconImageView.changeImageColor(color: .black)
		coatIconImageView.changeImageColor(color: .black)
		observationIconImageView.changeImageColor(color: .black)
		breedIconImageView.changeImageColor(color: .black)
		kindIconImageView.changeImageColor(color: .black)
		temperIconImageView.changeImageColor(color: .black)
		
		hideKeyboardWhenTappedAround()
		
    }

	@IBAction func changeAvatar(_ sender: Any) {
		MIBlurPopup.show(SelectPhotoSourcePopupRouter.createModule(delegate: self), on: self)
	}
}

extension AddPetViewControllerViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			profilePictureImageView.image = image
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
