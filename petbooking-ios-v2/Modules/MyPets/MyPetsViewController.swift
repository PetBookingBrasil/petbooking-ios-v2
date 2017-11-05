//
//  MyPetsViewController.swift
//  petbooking-ios-v2
//
//  Created Ryniere S Silva on 20/05/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import PINRemoteImage
import DZNEmptyDataSet

class MyPetsViewController: UIViewController, MyPetsViewProtocol {
	
	@IBOutlet weak var emptyView: UIView!
	@IBOutlet weak var tableView: UITableView!
	
	var presenter: MyPetsPresenterProtocol?
	
	var pets = [Pet]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setBackButton()
		title = NSLocalizedString("my_pets_title", comment: "")
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.emptyDataSetDelegate = self
		tableView.emptyDataSetSource = self
		
		tableView.register(UINib(nibName: "MyPetsTableViewCell", bundle: nil), forCellReuseIdentifier: "MyPetsCell")
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"add"), style: .plain, target: self, action: #selector(addPet))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		presenter?.reloadTableData()
	}
	
	func addPet() {
		presenter?.didTapAddPet()
	}
	
}

extension MyPetsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		emptyView.isHidden = pets.count > 0
		
		return pets.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell  = tableView.dequeueReusableCell(withIdentifier: "MyPetsCell") as! MyPetsTableViewCell
		
		let pet = pets[indexPath.row]
		
		cell.petNameLabel.text = pet.name
		cell.petBreedLabel.text = pet.breedName
		
		if pet.type == "dog" {
			cell.petPictureImageView.image = UIImage(named:"avatar-padrao-cachorro")
		} else {
			cell.petPictureImageView.image = UIImage(named:"avatar-padrao-gato")
		}
		
		
		if pet.photoThumbUrl.contains("http") {
			if let url = URL(string: pet.photoThumbUrl) {
				cell.petPictureImageView.pin_setImage(from: url)
			}
		} else {
			if let url = URL(string: "https://cdn.petbooking.com.br\(pet.photoThumbUrl)") {
				cell.petPictureImageView.pin_setImage(from: url)
			}
		}
		
		return cell
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let pet = pets[indexPath.row]
		
		navigationController?.pushViewController(AddPetViewControllerRouter.createModule(pet: pet, petViewType: .edit), animated: true)
		
	}
	
	func fillTableData(petList: PetList) {
		
		self.pets = petList.pets
		
		self.tableView.reloadData()
		
	}
	
}

extension MyPetsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
	
	func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
		
		
		return UIImage()
		
	}
	
	func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
		
		
		let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		indicator.startAnimating()
		
		return indicator
	}
	
	
}

