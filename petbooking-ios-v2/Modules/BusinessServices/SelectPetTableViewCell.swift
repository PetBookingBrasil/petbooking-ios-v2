//
//  SelectPetTableViewCell.swift
//  petbooking-ios-v2
//
//  Created by Ryniere S Silva on 22/10/17.
//  Copyright © 2017 Pet Booking Serviços e Desenvolvimento de Softwares SA. All rights reserved.
//

import UIKit

class SelectPetTableViewCell: UITableViewCell {

	@IBOutlet weak var panelView: UIView!
	@IBOutlet weak var pageControl: UIPageControl!
	@IBOutlet weak var collectionView: UICollectionView!
	
	var selectedPet:Pet = Pet()
	var petList:PetList = PetList()
	var thisWidth:CGFloat = 0
	
	weak var delegate:SelectPetTableViewCellDelegate?
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		panelView.layer.cornerRadius = 4
		panelView.dropShadow()
		
		thisWidth = CGFloat(self.frame.width/2)
		collectionView.delegate = self
		collectionView.dataSource = self
		
		collectionView.register(UINib(nibName: "PetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PetCollectionViewCell")
		
		pageControl.hidesForSinglePage = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension SelectPetTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageControl.numberOfPages = petList.pets.count / 2 + petList.pets.count % 2
		return petList.pets.count
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                    layout collectionViewLayout: UICollectionViewLayout,
	                    sizeForItemAt indexPath: IndexPath) -> CGSize {
		thisWidth = CGFloat(self.panelView.frame.width/2)
		return CGSize(width: thisWidth, height: 161)
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                    layout collectionViewLayout: UICollectionViewLayout,
	                    minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1.0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout
		collectionViewLayout: UICollectionViewLayout,
	                    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1.0
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row / 2
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
				
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCollectionViewCell", for: indexPath) as! PetCollectionViewCell
		
		let pet = petList.pets[indexPath.item]
		
		cell.isSelected = pet == selectedPet
		if pet == selectedPet {
			collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
		}
		
		cell.nameLabel.text = pet.name
		
		if pet.type == "dog" {
			cell.pictureImageView.image = UIImage(named:"avatar-padrao-cachorro")
		} else {
			cell.pictureImageView.image = UIImage(named:"avatar-padrao-gato")
		}
		if let url = URL(string: pet.photoThumbUrl) {
			cell.pictureImageView.pin_setImage(from: url)
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedPet = petList.pets[indexPath.item]
		delegate?.setSelectedPet(selectedPet: selectedPet)
	}
}

extension SelectPetTableViewCell: BusinessServicesViewControllerDelegate {
	func loadPets(petList: PetList) {
		self.petList = petList
		self.collectionView.reloadData()
	}
}

protocol SelectPetTableViewCellDelegate: class {
	func setSelectedPet(selectedPet: Pet)
}

